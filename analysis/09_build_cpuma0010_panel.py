#!/usr/bin/env python3
"""
Harmonize 2000- and 2010-vintage IPUMS PUMA outcome cells to CPUMA0010.

Canonical composition files are supplied by IPUMS USA.
No treatment variables or treatment-effect estimates are used here.
"""
from __future__ import annotations
import argparse, json, re
from pathlib import Path
import pandas as pd
import requests

URL_2000="https://usa.ipums.org/usa/resources/volii/CPUMA0010_PUMA2000_assignments.xls"
URL_2010="https://usa.ipums.org/usa/resources/volii/CPUMA0010_PUMA2010_components.xls"
DOC="https://usa.ipums.org/usa/volii/cpuma0010.shtml"
UA="death-of-local-best-research/0.4"

def norm(x):
    return re.sub(r"[^a-z0-9]","",str(x).lower())

def download(url,dest):
    r=requests.get(url,headers={"User-Agent":UA},timeout=120)
    r.raise_for_status()
    dest.write_bytes(r.content)

def first_sheet(path):
    x=pd.ExcelFile(path)
    sheet=next(s for s in x.sheet_names if "data_dictionary" not in s.lower())
    return pd.read_excel(path,sheet_name=sheet,dtype=str),sheet

def detect(df,vintage):
    cols=list(df.columns)
    n={c:norm(c) for c in cols}
    cp=next((c for c in cols if "cpuma0010" in n[c]),None)
    if cp is None:
        cp=next((c for c in cols if "cpuma" in n[c]),None)
    state=next((c for c in cols if n[c] in {"statefip","statefp","state"}),None)
    if state is None:
        state=next((c for c in cols if "state" in n[c] and "name" not in n[c]),None)

    # Prefer a PUMA column explicitly mentioning the source vintage.
    puma=next((c for c in cols if "puma" in n[c] and "cpuma" not in n[c] and vintage in n[c]),None)
    if puma is None:
        puma=next((c for c in cols if "puma" in n[c] and "cpuma" not in n[c]),None)

    if not all([cp,state,puma]):
        raise RuntimeError(f"Cannot identify fields in {vintage} mapping. Columns: {cols}")
    return state,puma,cp

def to_int(s):
    return pd.to_numeric(s.astype(str).str.extract(r"(\d+)",expand=False),errors="coerce").astype("Int64")

def mapping(path,vintage):
    d,sheet=first_sheet(path)
    state,puma,cp=detect(d,vintage)
    out=pd.DataFrame({
      "STATEFIP":to_int(d[state]),
      "PUMA":to_int(d[puma]),
      "CPUMA0010":to_int(d[cp])
    }).dropna().drop_duplicates()
    # Each source PUMA must have one deterministic CPUMA assignment.
    amb=out.groupby(["STATEFIP","PUMA"]).CPUMA0010.nunique()
    if (amb>1).any():
        raise RuntimeError(f"{vintage} mapping is not deterministic for {(amb>1).sum()} PUMAs")
    return out, {"sheet":sheet,"columns":list(d.columns),"rows":len(out),
                 "states":int(out.STATEFIP.nunique()),"cpumas":int(out.CPUMA0010.nunique())}

def aggregate_cells(d,keys):
    additive=[
      "n_workers","worker_weight","young_weight","selfemp_weight",
      "wage_sum_w","wage_weight","hours_sum_w","hours_weight"
    ]
    additive=[c for c in additive if c in d.columns]
    out=d.groupby(keys,as_index=False)[additive].sum(min_count=1)
    if "worker_weight" in out:
        out["young_20_29_share"]=out["young_weight"]/out["worker_weight"]
        out["selfemployment_share"]=out["selfemp_weight"]/out["worker_weight"]
    if "wage_weight" in out:
        out["mean_nominal_wage"]=out["wage_sum_w"]/out["wage_weight"]
    if "hours_weight" in out:
        out["mean_weekly_hours"]=out["hours_sum_w"]/out["hours_weight"]
    return out

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--puma-dir",default="data/derived/ipums_puma")
    ap.add_argument("--outdir",default="data/derived/ipums_cpuma0010")
    a=ap.parse_args()
    puma_dir=Path(a.puma_dir); out=Path(a.outdir); out.mkdir(parents=True,exist_ok=True)

    occ_path=puma_dir/"puma_occupation_year.csv"
    den_path=puma_dir/"puma_year_denominators.csv"
    if not occ_path.exists() or not den_path.exists():
        raise SystemExit("PUMA panel is not yet available.")

    f00=out/"_cpuma2000.xls"; f10=out/"_cpuma2010.xls"
    download(URL_2000,f00); download(URL_2010,f10)
    m00,q00=mapping(f00,"2000"); m10,q10=mapping(f10,"2010")
    maps=pd.concat([
      m00.assign(PUMA_VINTAGE="2000"),
      m10.assign(PUMA_VINTAGE="2010")
    ],ignore_index=True)

    occ=pd.read_csv(occ_path,low_memory=False)
    den=pd.read_csv(den_path,low_memory=False)
    for d in (occ,den):
        d["STATEFIP"]=pd.to_numeric(d["STATEFIP"],errors="coerce").astype("Int64")
        d["PUMA"]=pd.to_numeric(d["PUMA"],errors="coerce").astype("Int64")
        d["PUMA_VINTAGE"]=d["PUMA_VINTAGE"].astype(str)

    occ_use=occ[occ.PUMA_VINTAGE.isin(["2000","2010"])].copy()
    den_use=den[den.PUMA_VINTAGE.isin(["2000","2010"])].copy()
    occ_m=occ_use.merge(maps,on=["PUMA_VINTAGE","STATEFIP","PUMA"],how="left",validate="many_to_one",indicator=True)
    den_m=den_use.merge(maps,on=["PUMA_VINTAGE","STATEFIP","PUMA"],how="left",validate="many_to_one",indicator=True)

    occ_cov=float((occ_m["_merge"]=="both").mean())
    den_cov=float((den_m["_merge"]=="both").mean())
    if occ_cov < .995 or den_cov < .995:
        raise RuntimeError(f"CPUMA mapping coverage too low: occ={occ_cov}, den={den_cov}")

    occ_m=occ_m[occ_m._merge=="both"].drop(columns="_merge")
    den_m=den_m[den_m._merge=="both"].drop(columns="_merge")

    occ_cp=aggregate_cells(occ_m,["YEAR","STATEFIP","CPUMA0010","OCC2010"])
    den_metrics=[c for c in ["working_age_weight","employed_weight","n_persons"] if c in den_m]
    den_cp=den_m.groupby(["YEAR","STATEFIP","CPUMA0010"],as_index=False)[den_metrics].sum(min_count=1)

    # The ConsPUMA definition is designed for 2000-2021 only.
    occ_cp=occ_cp[(occ_cp.YEAR>=2000)&(occ_cp.YEAR<=2021)]
    den_cp=den_cp[(den_cp.YEAR>=2000)&(den_cp.YEAR<=2021)]

    occ_cp.to_csv(out/"cpuma0010_occupation_year.csv.gz",index=False,compression="gzip")
    den_cp.to_csv(out/"cpuma0010_year_denominators.csv.gz",index=False,compression="gzip")
    pd.concat([m00.assign(PUMA_VINTAGE="2000"),m10.assign(PUMA_VINTAGE="2010")]).to_csv(
      out/"cpuma0010_source_puma_assignments.csv",index=False)

    qa={
      "documentation":DOC,
      "puma2000_source":URL_2000,
      "puma2010_source":URL_2010,
      "puma2000_mapping":q00,
      "puma2010_mapping":q10,
      "occupation_cell_mapping_coverage":occ_cov,
      "denominator_cell_mapping_coverage":den_cov,
      "years":sorted(pd.to_numeric(occ_cp.YEAR).dropna().astype(int).unique().tolist()),
      "cpuma_occupation_cells":int(len(occ_cp)),
      "cpuma_year_cells":int(len(den_cp)),
      "treatment_effects_estimated":False
    }
    (out/"qa.json").write_text(json.dumps(qa,indent=2))
    f00.unlink(); f10.unlink()
    print(json.dumps(qa,indent=2))

if __name__=="__main__":
    main()
