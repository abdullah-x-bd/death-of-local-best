#!/usr/bin/env python3
"""
Acquire and inventory the historical NTIA BTOP/BIP treatment-source files.

This script is deliberately treatment-definition only:
- no labor-market outcomes are read;
- no funded-vs-rejected effect is estimated;
- the public Round-2 proposed-service-area aggregate is explicitly NOT
  interpreted as application-linked treatment geography.

Canonical sources are NTIA / Data.gov. Internet Archive is a transport fallback
for legacy files that reject cloud clients.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import io
import json
import re
import tempfile
from pathlib import Path
from urllib.parse import quote

import pandas as pd
import requests

UA = "death-of-local-best-research/0.2 (academic reproducibility)"
TIMEOUT = 120

SOURCES = {
    "applications": {
        "canonical": "http://www.ntia.doc.gov/broadbandgrants/applications/Comprehensive_Query_Results.xls",
        "alternates": [
            "https://www.ntia.doc.gov/broadbandgrants/applications/Comprehensive_Query_Results.xls",
        ],
        "direct_wayback": [
            "https://web.archive.org/web/20110429013531id_/http://www.ntia.doc.gov/broadbandgrants/applications/Comprehensive_Query_Results.xls",
        ],
        "kind": "excel",
        "description": "BTOP/BIP applications database",
    },
    "btop_map": {
        "canonical": "http://www2.ntia.doc.gov/BTOPmap/data/BTOP_Map_Data.xls",
        "alternates": [
            "https://www2.ntia.doc.gov/BTOPmap/data/BTOP_Map_Data.xls",
        ],
        "kind": "excel",
        "description": "BTOP awarded-project map data",
    },
    "round2_proposed_service_areas": {
        "canonical": "https://www2.ntia.gov/files/BTOP_Proposed_Funded_Service_Area_Tract_and_BlockGroup_Numbers.csv",
        "alternates": [],
        "kind": "csv",
        "description": "Aggregate list of Round 2 CCI proposed tracts/block groups, NOT application-linked",
    },
}

ARCHIVE_PAGE = "https://www2.ntia.gov/archives"


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def plausible_excel(content: bytes) -> bool:
    # xls OLE or xlsx ZIP
    return content.startswith(bytes.fromhex("D0CF11E0A1B11AE1")) or content.startswith(b"PK\x03\x04")


def plausible_csv(content: bytes) -> bool:
    head = content[:4096].lstrip().lower()
    if not content or head.startswith(b"<!doctype") or head.startswith(b"<html"):
        return False
    # NTIA's Round 2 "CSV" is effectively a one-identifier-per-line text file,
    # so requiring a comma would falsely reject the official download.
    text = head.decode("utf-8", errors="ignore")
    return bool("," in text or re.search(r"(?m)^\D*\d{11,12}\D*$", text))


def request_bytes(url: str):
    try:
        r = requests.get(
            url,
            headers={"User-Agent": UA, "Accept": "*/*"},
            timeout=TIMEOUT,
            allow_redirects=True,
        )
        return r.status_code, r.url, r.content, r.headers.get("content-type", "")
    except Exception as e:
        return None, url, b"", repr(e)


def wayback_candidates(original_url: str):
    cdx = (
        "https://web.archive.org/cdx/search/cdx?"
        + "url=" + quote(original_url, safe="")
        + "&output=json&filter=statuscode:200&collapse=digest"
        + "&from=2009&to=2016&fl=timestamp,original,statuscode,mimetype,digest,length"
    )
    status, final, body, ctype = request_bytes(cdx)
    if status != 200:
        return [], {"cdx_url": cdx, "status": status, "content_type": ctype}
    try:
        rows = json.loads(body.decode("utf-8"))
    except Exception:
        return [], {"cdx_url": cdx, "status": status, "parse_error": True}
    if not rows or len(rows) < 2:
        return [], {"cdx_url": cdx, "status": status, "captures": 0}
    header = rows[0]
    out = [dict(zip(header, row)) for row in rows[1:]]
    # Prefer later snapshots because final Round 2 status may have been added later.
    out.sort(key=lambda x: x.get("timestamp", ""), reverse=True)
    return out, {"cdx_url": cdx, "status": status, "captures": len(out)}


def acquire(name: str, spec: dict, rawdir: Path):
    ext = ".xls" if spec["kind"] == "excel" else ".csv"
    dest = rawdir / f"{name}{ext}"
    attempts = []

    for url in [spec["canonical"], *spec.get("alternates", [])]:
        status, final, body, ctype = request_bytes(url)
        ok = plausible_excel(body) if spec["kind"] == "excel" else plausible_csv(body)
        attempts.append({
            "transport": "live",
            "requested_url": url,
            "final_url": final,
            "status": status,
            "content_type": ctype,
            "bytes": len(body),
            "valid_signature": ok,
        })
        if status == 200 and ok:
            dest.write_bytes(body)
            return dest, attempts, {"transport": "live", "source_url": url}

    # Known verified archive snapshots are tried before the CDX index, which
    # is intermittently unavailable from cloud runners.
    for archived in spec.get("direct_wayback", []):
        status, final, body, ctype = request_bytes(archived)
        ok = plausible_excel(body) if spec["kind"] == "excel" else plausible_csv(body)
        attempts.append({
            "transport": "direct_wayback",
            "requested_url": archived,
            "final_url": final,
            "status": status,
            "content_type": ctype,
            "bytes": len(body),
            "valid_signature": ok,
        })
        if status == 200 and ok:
            dest.write_bytes(body)
            return dest, attempts, {
                "transport": "direct_wayback",
                "archived_url": archived,
            }

    # Search captures for both canonical and alternates.
    seen = set()
    for original in [spec["canonical"], *spec.get("alternates", [])]:
        captures, cdxmeta = wayback_candidates(original)
        attempts.append({"transport": "wayback_cdx", "original": original, **cdxmeta})
        for cap in captures[:25]:
            ts = cap["timestamp"]
            archived = f"https://web.archive.org/web/{ts}id_/{original}"
            if archived in seen:
                continue
            seen.add(archived)
            status, final, body, ctype = request_bytes(archived)
            ok = plausible_excel(body) if spec["kind"] == "excel" else plausible_csv(body)
            attempts.append({
                "transport": "wayback",
                "capture_timestamp": ts,
                "original": original,
                "requested_url": archived,
                "final_url": final,
                "status": status,
                "content_type": ctype,
                "bytes": len(body),
                "valid_signature": ok,
            })
            if status == 200 and ok:
                dest.write_bytes(body)
                return dest, attempts, {
                    "transport": "wayback",
                    "source_url": original,
                    "capture_timestamp": ts,
                    "archived_url": archived,
                }

    return None, attempts, None


def normalize_columns(cols):
    return [re.sub(r"\s+", " ", str(c)).strip() for c in cols]


def excel_inventory(path: Path, source_name: str):
    rows = []
    # Let pandas infer engine from signature; install xlrd/openpyxl in workflow.
    xls = pd.ExcelFile(path)
    for sheet in xls.sheet_names:
        try:
            d = pd.read_excel(path, sheet_name=sheet, dtype=str)
            rows.append({
                "source": source_name,
                "sheet": sheet,
                "n_rows": int(len(d)),
                "n_columns": int(len(d.columns)),
                "columns": " | ".join(normalize_columns(d.columns)),
            })
        except Exception as e:
            rows.append({
                "source": source_name,
                "sheet": sheet,
                "n_rows": None,
                "n_columns": None,
                "columns": "",
                "error": repr(e),
            })
    return rows


def applications_audit(path: Path):
    xls = pd.ExcelFile(path)
    audits = []
    candidates = []
    for sheet in xls.sheet_names:
        try:
            d = pd.read_excel(path, sheet_name=sheet, dtype=str)
        except Exception:
            continue
        for c in d.columns:
            n = re.sub(r"[^a-z0-9]", "", str(c).lower())
            if any(k in n for k in [
                "status", "outcome", "classification", "round", "program",
                "projecttype", "application", "easygrants", "state", "county",
                "projectarea", "servicearea", "award", "score", "rating",
                "requested", "funding", "rural"
            ]):
                candidates.append((sheet, c))
                vc = d[c].fillna("<NA>").astype(str).str.strip().value_counts(dropna=False).head(50)
                for val, count in vc.items():
                    audits.append({
                        "sheet": sheet,
                        "column": str(c),
                        "value": val,
                        "count": int(count),
                    })
    return candidates, audits


def service_area_audit(path: Path):
    d = pd.read_csv(path, dtype=str, keep_default_na=False)
    # Do not coerce identifiers to numeric. Leading zero preservation is essential.
    rows = int(len(d))
    cols = normalize_columns(d.columns)
    # Find the most identifier-like column.
    best = None
    best_share = -1
    for c in d.columns:
        s = d[c].astype(str).str.strip()
        share = s.str.fullmatch(r"\d{11,12}").mean()
        if share > best_share:
            best_share = float(share)
            best = c
    out = {
        "rows": rows,
        "columns": cols,
        "identifier_column_candidate": str(best) if best is not None else None,
        "share_11_or_12_digit": best_share if best is not None else None,
    }
    if best is not None:
        s = d[best].astype(str).str.strip()
        valid = s[s.str.fullmatch(r"\d{11,12}")]
        out.update({
            "valid_identifier_rows": int(len(valid)),
            "unique_identifiers": int(valid.nunique()),
            "tract_11_digit_rows": int((valid.str.len() == 11).sum()),
            "blockgroup_12_digit_rows": int((valid.str.len() == 12).sum()),
            "states_by_prefix": int(valid.str[:2].nunique()) if len(valid) else 0,
            "counties_by_prefix": int(valid.str[:5].nunique()) if len(valid) else 0,
        })
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--outdir", default="outputs/ntia_inventory")
    args = ap.parse_args()
    out = Path(args.outdir)
    rawdir = out / "_raw"
    rawdir.mkdir(parents=True, exist_ok=True)

    manifest = {
        "archive_page": ARCHIVE_PAGE,
        "purpose": "treatment-source inventory only; no outcome data used",
        "sources": {},
        "public_service_area_warning": (
            "NTIA states the public Round 2 CCI proposed tract/block-group list "
            "is NOT listed according to specific applications. It cannot by itself "
            "identify funded versus rejected application geography."
        ),
    }
    excel_rows = []
    app_audit_rows = []
    app_candidate_cols = []
    failures = []

    for name, spec in SOURCES.items():
        path, attempts, chosen = acquire(name, spec, rawdir)
        rec = {
            "description": spec["description"],
            "canonical_url": spec["canonical"],
            "chosen": chosen,
            "attempts": attempts,
        }
        if path is None:
            rec["acquired"] = False
            failures.append(name)
        else:
            rec.update({
                "acquired": True,
                "filename": path.name,
                "size_bytes": path.stat().st_size,
                "sha256": sha256(path),
            })
            if spec["kind"] == "excel":
                excel_rows.extend(excel_inventory(path, name))
                if name == "applications":
                    app_candidate_cols, app_audit_rows = applications_audit(path)
            elif name == "round2_proposed_service_areas":
                rec["audit"] = service_area_audit(path)
        manifest["sources"][name] = rec

    pd.DataFrame(excel_rows).to_csv(out / "excel_sheet_inventory.csv", index=False)
    pd.DataFrame(app_audit_rows).to_csv(out / "applications_categorical_audit.csv", index=False)
    pd.DataFrame(
        [{"sheet": s, "column": c} for s, c in app_candidate_cols]
    ).to_csv(out / "applications_candidate_columns.csv", index=False)

    # Raw source files are public, but this first workflow uploads them only as an
    # artifact. A separate freeze step can attach verified snapshots to a release.
    (out / "source_manifest.json").write_text(json.dumps(manifest, indent=2))
    (out / "identification_gate.json").write_text(json.dumps({
        "application_database_acquired": bool(manifest["sources"]["applications"].get("acquired")),
        "btop_map_acquired": bool(manifest["sources"]["btop_map"].get("acquired")),
        "aggregate_round2_service_area_list_acquired": bool(
            manifest["sources"]["round2_proposed_service_areas"].get("acquired")
        ),
        "application_linked_rejected_service_area_geometry_available": False,
        "near_cutoff_score_design_operational": False,
        "reason_near_cutoff_not_yet_operational": (
            "Public review documents establish score-based advancement, but the "
            "application-level merit scores / threshold data have not yet been "
            "recovered and validated."
        ),
        "treatment_effect_regression_allowed": False,
        "unresolved_sources": failures,
    }, indent=2))

    print(json.dumps({
        "acquired": {
            k: v.get("acquired", False) for k, v in manifest["sources"].items()
        },
        "failures": failures,
        "application_candidate_columns": len(app_candidate_cols),
        "treatment_effect_regression_allowed": False,
    }, indent=2))

if __name__ == "__main__":
    main()
