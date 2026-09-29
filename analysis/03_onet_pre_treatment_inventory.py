#!/usr/bin/env python3
"""
Inventory historical O*NET 4.0/5.0 descriptors for blind pre-treatment
market-shelter measurement.

This script does NOT estimate outcome regressions and does NOT choose weights
using labor-market outcomes.
"""
from __future__ import annotations
import argparse, csv, json, re, zipfile
from pathlib import Path
import pandas as pd

def read_tab(path: Path) -> pd.DataFrame:
    errors=[]
    for enc in ("utf-8-sig","cp1252","latin1"):
        try:
            return pd.read_csv(path, sep="\t", dtype=str, encoding=enc, low_memory=False)
        except Exception as e:
            errors.append(f"{enc}: {e}")
    raise RuntimeError(f"Cannot read {path}: {errors}")

def clean(s):
    return re.sub(r"\s+"," ",str(s)).strip()

def find_col(cols, candidates):
    norm={re.sub(r"[^a-z0-9]","",c.lower()):c for c in cols}
    for cand in candidates:
        k=re.sub(r"[^a-z0-9]","",cand.lower())
        if k in norm: return norm[k]
    return None

def looks_tabular_text(p: Path) -> bool:
    try:
        raw=p.read_bytes()[:8192]
        if not raw or b"\x00" in raw:
            return False
        return b"\t" in raw or p.suffix.lower() in (".txt",".tsv",".dat")
    except Exception:
        return False

def inventory_release(root: Path, release: str):
    files=sorted(p for p in root.rglob("*") if p.is_file())
    table_rows=[]
    desc=[]
    members=[]
    for p in files:
        members.append({
            "release":release,
            "member":str(p.relative_to(root)),
            "size_bytes":p.stat().st_size,
            "suffix":p.suffix.lower()
        })
        if not looks_tabular_text(p):
            continue
        try:
            df=read_tab(p)
        except Exception:
            continue
        cols=list(df.columns)
        soc=find_col(cols,["O*NET-SOC Code","ONET-SOC Code","O*NET SOC Code"])
        eid=find_col(cols,["Element ID"])
        ename=find_col(cols,["Element Name"])
        scale=find_col(cols,["Scale ID"])
        dval=find_col(cols,["Data Value"])
        table_rows.append({
            "release":release,
            "table":p.name,
            "rows":len(df),
            "columns":" | ".join(cols),
            "occupation_count":int(df[soc].nunique()) if soc else None,
            "has_element_id":bool(eid),
            "has_element_name":bool(ename),
            "has_scale":bool(scale),
            "has_data_value":bool(dval),
        })
        if eid and ename:
            keep=[eid,ename]
            if scale: keep.append(scale)
            if soc: keep.append(soc)
            x=df[keep].copy()
            x[eid]=x[eid].map(clean)
            x[ename]=x[ename].map(clean)
            group=[eid,ename]
            agg={}
            if scale:
                agg[scale]=lambda s:" | ".join(sorted({clean(v) for v in s.dropna()}))
            if soc:
                agg[soc]="nunique"
            if agg:
                y=x.groupby(group,dropna=False).agg(agg).reset_index()
            else:
                y=x[group].drop_duplicates()
            for _,r in y.iterrows():
                desc.append({
                    "release":release,
                    "table":p.name,
                    "element_id":r[eid],
                    "element_name":r[ename],
                    "scales":r[scale] if scale else "",
                    "occupation_count":int(r[soc]) if soc and pd.notna(r[soc]) else None,
                })
    return pd.DataFrame(table_rows),pd.DataFrame(desc),pd.DataFrame(members)

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--bundle",required=True,help="onet.tar.gz from public-data-core release")
    ap.add_argument("--outdir",default="outputs/onet_inventory")
    a=ap.parse_args()
    out=Path(a.outdir); out.mkdir(parents=True,exist_ok=True)
    work=out/"_work"; work.mkdir(exist_ok=True)

    import tarfile
    with tarfile.open(a.bundle,"r:gz") as t:
        t.extractall(work, filter="data")

    zips=sorted(work.rglob("db_*.zip"))
    if not zips:
        raise SystemExit("No O*NET db_*.zip archives found")

    summaries=[]; descriptors=[]; member_sets=[]
    for z in zips:
        m=re.search(r"db_(\d+)_(\d+)|db_(\d+)",z.name)
        rel=z.stem.replace("db_","").replace("_",".")
        target=work/f"release_{rel}"
        target.mkdir(exist_ok=True)
        with zipfile.ZipFile(z) as zz:
            zz.extractall(target)
        t,d,members=inventory_release(target,rel)
        summaries.append(t); descriptors.append(d); member_sets.append(members)

    tables=pd.concat(summaries,ignore_index=True)
    desc=pd.concat(descriptors,ignore_index=True).drop_duplicates()
    members=pd.concat(member_sets,ignore_index=True)

    members.to_csv(out/"archive_member_inventory.csv",index=False)
    tables.to_csv(out/"historical_onet_table_inventory.csv",index=False)
    desc.to_csv(out/"historical_onet_descriptor_inventory.csv",index=False)

    # Blind candidate sheet: lexical retrieval only. No outcome data enter.
    terms=[
      "computer","electronic","face-to-face","face to face","physical proximity",
      "contact with others","public","customer","client","people","communicat",
      "performing","selling","assist","care","vehicle","equipment","machine",
      "handling","moving objects","outdoors","indoors","telephone","email"
    ]
    pattern="|".join(re.escape(x) for x in terms)
    candidate=desc[
        desc["element_name"].str.lower().str.contains(pattern,regex=True,na=False)
    ].copy()
    candidate["selection_reason"]="lexical pre-screen only; final inclusion requires theory rule frozen before outcome regression"
    candidate.to_csv(out/"blind_candidate_descriptor_sheet.csv",index=False)

    meta={
      "archives":[z.name for z in zips],
      "table_rows":len(tables),
      "unique_descriptor_rows":len(desc),
      "candidate_descriptor_rows":len(candidate),
      "rule":"No labor-market outcomes or treatment-effect estimates used in descriptor retrieval.",
    }
    (out/"qa.json").write_text(json.dumps(meta,indent=2))

    import shutil
    shutil.rmtree(work)
    print(json.dumps(meta,indent=2))

if __name__=="__main__":
    main()
