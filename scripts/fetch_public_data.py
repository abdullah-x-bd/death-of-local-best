#!/usr/bin/env python3
from __future__ import annotations
import argparse, hashlib, json, re, time
from pathlib import Path
from urllib.parse import urljoin
import requests
from bs4 import BeautifulSoup

UA = "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"
TIMEOUT = 120
S = requests.Session()
S.headers.update({
    "User-Agent": UA,
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.8",
    "Connection": "keep-alive",
    "From": "https://github.com/abdullah-x-bd/death-of-local-best",
})

def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for b in iter(lambda: f.read(1024 * 1024), b""):
            h.update(b)
    return h.hexdigest()

def download(url: str, dest: Path, required=True):
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and dest.stat().st_size:
        return {"url": url, "path": str(dest), "size": dest.stat().st_size, "sha256": sha256(dest), "cached": True}
    tmp = Path(str(dest) + ".part")
    last = None
    candidates = [url]
    if url.startswith("https://download.bls.gov/"):
        candidates.append("http://" + url[len("https://"):])
    for attempt in range(4):
        request_url = candidates[min(attempt, len(candidates)-1)]
        try:
            with S.get(request_url, stream=True, timeout=TIMEOUT, allow_redirects=True) as r:
                if r.status_code >= 400:
                    raise RuntimeError(f"HTTP {r.status_code}")
                final_url = r.url
                with tmp.open("wb") as f:
                    for chunk in r.iter_content(1024 * 1024):
                        if chunk:
                            f.write(chunk)
            tmp.replace(dest)
            return {"url": url, "request_url": request_url, "final_url": final_url, "path": str(dest), "size": dest.stat().st_size, "sha256": sha256(dest), "cached": False}
        except Exception as e:
            last = repr(e)
            if tmp.exists():
                tmp.unlink()
            time.sleep(2 ** attempt)
    if required:
        raise RuntimeError(f"Failed: {url}: {last}")
    return {"url": url, "error": last}

def get_html(url):
    r = S.get(url, timeout=TIMEOUT)
    r.raise_for_status()
    return r.text, r.url

def fetch_onet(root: Path):
    return [
        download("https://www.onetcenter.org/dl_files/db_40.zip", root/"onet"/"db_40.zip"),
        download("https://www.onetcenter.org/dl_files/db_50.zip", root/"onet"/"db_50.zip"),
    ]

def fetch_oews(root: Path):
    # Use the official BLS download server rather than scraping bls.gov.
    # The BLS OEWS time-series documentation describes these files as
    # containing series-level observations with year/period and mapping files.
    base = "https://download.bls.gov/pub/time.series/OE/"
    files = [
        "oe.data.1.AllData",
        "oe.area",
        "oe.areatype",
        "oe.datatype",
        "oe.footnote",
        "oe.industry",
        "oe.occupation",
        "oe.release",
        "oe.seasonal",
        "oe.sector",
        "oe.txt",
    ]
    out = []
    for fn in files:
        out.append(download(base + fn, root/"oews"/fn))
    return out

def fetch_cbp(root: Path):
    out = []
    for y in range(1986, 2024):
        yy = str(y)[-2:]
        u = f"https://www2.census.gov/programs-surveys/cbp/datasets/{y}/cbp{yy}co.zip"
        out.append(download(u, root/"cbp"/f"cbp{yy}co.zip"))
    return out

def fetch_nonemployer(root: Path):
    out = []
    for y in range(1997, 2024):
        yy = str(y)[-2:]
        urls = [
            f"https://www2.census.gov/programs-surveys/nonemployer-statistics/datasets/{y}/historical-datasets/nonemp{yy}co.zip",
            f"https://www2.census.gov/programs-surveys/nonemployer-statistics/datasets/{y}/nonemp{yy}co.zip",
        ]
        found = None
        for u in urls:
            rec = download(u, root/"nonemployer"/f"nonemp{yy}co.zip", required=False)
            if "error" not in rec:
                found = rec
                break
        if found is None:
            raise RuntimeError(f"Nonemployer county file unresolved for {y}")
        out.append(found)
    return out

def fetch_qcew(root: Path):
    out = []
    for y in range(1990, 2026):
        u = f"https://data.bls.gov/cew/data/files/{y}/csv/{y}_annual_singlefile.zip"
        out.append(download(u, root/"qcew"/f"{y}_annual_singlefile.zip"))
    return out

def fetch_ntia(root: Path):
    out = []
    for fn, u in [
        ("Comprehensive_Query_Results.xls", "https://www.ntia.doc.gov/broadbandgrants/applications/Comprehensive_Query_Results.xls"),
        ("BTOP_Map_Data.xls", "https://www2.ntia.doc.gov/BTOPmap/data/BTOP_Map_Data.xls"),
    ]:
        rec = download(u, root/"ntia"/fn, required=False)
        if "error" in rec:
            rec = download(u.replace("https://","http://"), root/"ntia"/fn)
        out.append(rec)
    html, base = get_html("https://www2.ntia.gov/June-2010-datasets")
    soup = BeautifulSoup(html, "html.parser")
    picked = []
    for a in soup.find_all("a", href=True):
        href = a["href"]
        txt = " ".join(a.get_text(" ", strip=True).lower().split())
        if "sbdd-usa-fall2010" in href.lower() or "usa_datapackage" in href.lower() or "national data package" in txt:
            picked.append(urljoin(base, href))
    for u in sorted(set(picked)):
        fn = Path(u.split("?")[0]).name
        out.append(download(u, root/"ntia"/fn))
    return out

def select_link(page, needle):
    html, base = get_html(page)
    soup = BeautifulSoup(html, "html.parser")
    for a in soup.find_all("a", href=True):
        txt = " ".join(a.get_text(" ", strip=True).lower().split())
        if needle.lower() in txt:
            return urljoin(base, a["href"])
    raise RuntimeError(f"No link containing {needle!r} on {page}")

def fetch_ofcom(root: Path):
    page = "https://www.ofcom.org.uk/phones-and-broadband/coverage-and-speeds/connected-nations-2023/data-downloads"
    out = [
        download(select_link(page, "Fixed coverage postcode unit data"), root/"ofcom"/"2023_fixed_postcode.zip"),
        download(select_link(page, "Fixed coverage census output area data"), root/"ofcom"/"2023_fixed_output_area.zip"),
    ]
    u = "https://www.ofcom.org.uk/siteassets/resources/documents/research-and-data/multi-sector/infrastructure-research/connected-nations-2025/202507_fixed_broadband_coverage_r01.zip?v=407830"
    out.append(download(u, root/"ofcom"/"2025_fixed_broadband_coverage.zip"))
    return out

FETCHERS = {
    "onet": fetch_onet,
    "oews": fetch_oews,
    "cbp": fetch_cbp,
    "nonemployer": fetch_nonemployer,
    "qcew": fetch_qcew,
    "ntia": fetch_ntia,
    "ofcom": fetch_ofcom,
}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default="data/raw_public")
    ap.add_argument("--sources", nargs="+", default=list(FETCHERS))
    ap.add_argument("--manifest", default="data/raw_public_manifest.json")
    args = ap.parse_args()
    root = Path(args.root)
    records = []
    for src in args.sources:
        print(f"== {src} ==", flush=True)
        recs = FETCHERS[src](root)
        for rec in recs:
            rec["source"] = src
        records.extend(recs)
    m = Path(args.manifest)
    m.parent.mkdir(parents=True, exist_ok=True)
    m.write_text(json.dumps(records, indent=2, sort_keys=True))
    print(f"Wrote {m}: {len(records)} files")

if __name__ == "__main__":
    main()
