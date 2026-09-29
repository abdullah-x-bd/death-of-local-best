#!/usr/bin/env python3
"""
Build frozen pre-treatment O*NET exposure scores and map them to IPUMS OCC2010.

No treatment-effect estimates are read or produced by this script.
Crosswalk rules are frozen in docs/onet_exposure_freeze_v0.md.
"""
from __future__ import annotations
import argparse, io, json, re, shutil, tarfile, tempfile, zipfile
from pathlib import Path
import numpy as np
import pandas as pd
import requests

UA="death-of-local-best-research/0.1"
ONET_BUNDLE="https://github.com/abdullah-x-bd/death-of-local-best/releases/download/public-data-core-v0.1/onet.tar.gz"
BLS_SOC_URLS=["https://www.bls.gov/soc/soc_2000_to_2010_crosswalk.xls","https://raw.githubusercontent.com/sidsatya/ailabor/9ba422152072e900899f4acd84d95575422af29f/data/occsoc_crosswalks/soc_2000_to_2010_crosswalk.csv"]
BLS_CENSUS_HTML="https://www.bls.gov/cps/cenocc2010.htm"\nCENSUS2010_FALLBACK_CSV="https://raw.githubusercontent.com/lowmason/agent-skills/617f5c663ae2a586fd03f0893f36d58864469022/skills/classification-codes/data/census_occ_2010.csv"

ITEMS={
 "computer_mediated":{
   "4.A.3.b.1":("WorkActivity","IM","Interacting With Computers"),
 },
 "physical_dependence":{
   "4.A.3.a.1":("WorkActivity","IM","Performing General Physical Activities"),
   "4.A.3.a.2":("WorkActivity","IM","Handling and Moving Objects"),
   "4.A.3.a.4":("WorkActivity","IM","Operating Vehicles, Mechanized Devices, or Equipment"),
 },
 "relational_public":{
   "4.C.1.a.4":("WorkContext","CX","Contact With Others"),
   "4.C.1.b.1.f":("WorkContext","CX","Deal With External Customers"),
   "4.A.4.a.8":("WorkActivity","IM","Performing for or Working Directly with the Public"),
   "4.A.4.a.5":("WorkActivity","IM","Assisting and Caring for Others"),
 }
}

def norm(s):
    return re.sub(r"[^a-z0-9]","",str(s).lower())

def get(url: str, dest: Path):
    headers={"User-Agent":UA}
    for attempt in range(4):
        try:
            r=requests.get(url,headers=headers,timeout=120,allow_redirects=True)
            if r.status_code==200 and len(r.content)>100:
                dest.parent.mkdir(parents=True,exist_ok=True)
                dest.write_bytes(r.content)
                return url
            err=f"HTTP {r.status_code}, {len(r.content)} bytes"
        except Exception as e:
            err=repr(e)
    raise RuntimeError(f"Download failed {url}: {err}")

def get_any(urls, dest: Path):
    errors=[]
    for url in urls:
        try:
            used=get(url,dest)
            return used
        except Exception as e:
            errors.append(f"{url}: {e}")
    raise RuntimeError("All download sources failed: "+" | ".join(errors))

def read_tab(path: Path):
    for enc in ("utf-8-sig","cp1252","latin1"):
        try:
            return pd.read_csv(path,sep="\t",dtype=str,encoding=enc,low_memory=False)
        except Exception:
            pass
    raise RuntimeError(f"Cannot read {path}")

def find_file(root: Path, stem: str):
    cand=[p for p in root.rglob("*") if p.is_file() and p.stem.lower()==stem.lower()]
    if not cand:
        raise RuntimeError(f"Missing table {stem}")
    return cand[0]

def zscore(s):
    x=pd.to_numeric(s,errors="coerce")
    sd=x.std(ddof=0)
    if not np.isfinite(sd) or sd==0:
        return x*np.nan
    return (x-x.mean())/sd

def extract_onet4(bundle: Path, work: Path):
    with tarfile.open(bundle,"r:gz") as t:
        t.extractall(work,filter="data")
    zips=list(work.rglob("db_40.zip"))
    if not zips:
        raise RuntimeError("db_40.zip not found in frozen O*NET bundle")
    out=work/"onet40"
    out.mkdir(exist_ok=True)
    with zipfile.ZipFile(zips[0]) as z:
        z.extractall(out)
    return out

def build_onet_scores(root: Path):
    frames={}
    for domain in ("WorkActivity","WorkContext"):
        p=find_file(root,domain)
        d=read_tab(p)
        cols={norm(c):c for c in d.columns}
        soc=cols["onetsoccode"]; eid=cols["elementid"]; scale=cols["scaleid"]; val=cols["datavalue"]
        d=d[[soc,eid,scale,val]].copy()
        d.columns=["onet_soc2000","element_id","scale_id","value"]
        frames[domain]=d

    item_rows=[]
    wide=None
    for component,spec in ITEMS.items():
        component_cols=[]
        for eid,(domain,scale,title) in spec.items():
            d=frames[domain]
            x=d[(d.element_id==eid)&(d.scale_id==scale)].copy()
            x["value"]=pd.to_numeric(x["value"],errors="coerce")
            # one row per occupation/item/scale in the 4.0 analyst database
            x=x.groupby("onet_soc2000",as_index=False)["value"].mean()
            col="item_"+eid.replace(".","_")
            x[col]=zscore(x["value"])
            x=x[["onet_soc2000",col]]
            component_cols.append(col)
            wide=x if wide is None else wide.merge(x,on="onet_soc2000",how="outer")
            item_rows.append({
                "component":component,"element_id":eid,"scale_id":scale,
                "element_name":title,"occupation_count":int(x[col].notna().sum())
            })
        if wide is None:
            raise RuntimeError("No O*NET scores built")

    # Require complete components as frozen.
    for component,spec in ITEMS.items():
        cols=["item_"+eid.replace(".","_") for eid in spec]
        wide[component+"_raw"]=wide[cols].mean(axis=1,skipna=False)
        wide[component]=zscore(wide[component+"_raw"])

    wide["remote_feasibility_proxy_raw"]=wide["computer_mediated"]-wide["physical_dependence"]
    wide["remote_feasibility_proxy"]=zscore(wide["remote_feasibility_proxy_raw"])
    wide["partial_market_shelter_proxy_raw"]=(
        wide["physical_dependence"]+wide["relational_public"]-wide["computer_mediated"]
    )
    wide["partial_market_shelter_proxy"]=zscore(wide["partial_market_shelter_proxy_raw"])
    wide["soc2000"]=wide["onet_soc2000"].str.extract(r"(\d{2}-\d{4})",expand=False)

    # Collapse data-level O*NET extensions equally within 2000 SOC parent.
    score_cols=["computer_mediated","physical_dependence","relational_public",
                "remote_feasibility_proxy","partial_market_shelter_proxy"]
    by2000=wide.groupby("soc2000",as_index=False).agg(
        **{c:(c,"mean") for c in score_cols},
        n_onet_occupations=("onet_soc2000","nunique")
    )
    return wide,by2000,pd.DataFrame(item_rows)

def detect_crosswalk_columns(df):
    cols=list(df.columns)
    c2000=None;c2010=None
    for c in cols:
        n=norm(c)
        if "2000" in n and "code" in n and c2000 is None: c2000=c
        if "2010" in n and "code" in n and c2010 is None: c2010=c
    if c2000 and c2010:
        return c2000,c2010
    # fallback based on SOC-looking contents and relative column order
    soccols=[]
    for c in cols:
        vals=df[c].astype(str)
        frac=vals.str.contains(r"\d{2}-\d{4}",regex=True).mean()
        if frac>.3: soccols.append(c)
    if len(soccols)>=2:
        return soccols[0],soccols[-1]
    raise RuntimeError(f"Could not detect SOC crosswalk columns: {cols}")

def read_bls_2000_2010(path: Path):
    rawbytes=path.read_bytes()[:16]
    if rawbytes.startswith(b"\xef\xbb\xbf") or b"," in path.read_bytes()[:256]:
        d=pd.read_csv(path,dtype=str,encoding="utf-8-sig")
    else:
        raw=pd.read_excel(path,header=None,dtype=str,engine="xlrd")
        header=0
        for i,row in raw.head(25).iterrows():
            txt=" ".join(row.fillna("").astype(str))
            if "2000" in txt and "2010" in txt and "SOC" in txt:
                header=i;break
        d=pd.read_excel(path,header=header,dtype=str,engine="xlrd")
    c0,c1=detect_crosswalk_columns(d)
    out=d[[c0,c1]].copy()
    out.columns=["soc2000_raw","soc2010_raw"]
    out["soc2000"]=out.soc2000_raw.astype(str).str.extract(r"(\d{2}-\d{4})",expand=False)
    out["soc2010"]=out.soc2010_raw.astype(str).str.extract(r"(\d{2}-\d{4})",expand=False)
    return out.dropna(subset=["soc2000","soc2010"]).drop_duplicates()[["soc2000","soc2010"]]

def build_soc2010(by2000,cw):
    score_cols=["computer_mediated","physical_dependence","relational_public",
                "remote_feasibility_proxy","partial_market_shelter_proxy"]
    x=cw.merge(by2000,on="soc2000",how="left")
    agg={c:(c,"mean") for c in score_cols}
    agg.update({
        "n_soc2000_sources":("soc2000","nunique"),
        "n_scored_soc2000":("computer_mediated",lambda s:int(s.notna().sum()))
    })
    out=x.groupby("soc2010",as_index=False).agg(**agg)
    return out

def parse_census2010():
    headers={"User-Agent":UA}
    try:
        html=requests.get(BLS_CENSUS_HTML,headers=headers,timeout=120)
        html.raise_for_status()
        tables=pd.read_html(io.StringIO(html.text))
        target=None
        for d in tables:
            ns=[norm(c) for c in d.columns]
            if any("2010censuscode" in n for n in ns) and any("2010soccode" in n for n in ns):
                target=d;break
        if target is None:
            raise RuntimeError("Could not find BLS Census 2010 occupation table")
        cols={norm(c):c for c in target.columns}
        occcol=next(c for n,c in cols.items() if "2010censuscode" in n)
        soccol=next(c for n,c in cols.items() if "2010soccode" in n)
        titlecol=next((c for n,c in cols.items() if "occupationtitle" in n),target.columns[0])
        rows=[]
        for _,r in target.iterrows():
            occs=re.findall(r"(?<!\\d)(\\d{4})(?!\\d)",str(r[occcol]))
            socs=re.findall(r"\\d{2}-\\d{4}",str(r[soccol]))
            if len(occs)!=1 or not socs:
                continue
            for soc in socs:
                rows.append({"OCC2010":int(occs[0]),"census_title":str(r[titlecol]),"census_soc2010":soc})
        out=pd.DataFrame(rows).drop_duplicates()
        if len(out) < 500:
            raise RuntimeError(f"BLS Census mapping unexpectedly small: {len(out)}")
        return out, BLS_CENSUS_HTML
    except Exception:
        r=requests.get(CENSUS2010_FALLBACK_CSV,headers=headers,timeout=120)
        r.raise_for_status()
        d=pd.read_csv(io.StringIO(r.text),dtype=str)
        if len(d) < 530:
            raise RuntimeError(f"Fallback Census mapping unexpectedly small: {len(d)}")
        out=d[d["census_occ"].str.fullmatch(r"\\d{4}",na=False) & d["soc_code"].notna()].copy()
        out["OCC2010"]=out["census_occ"].astype(int)
        out["census_title"]=out["title"]
        out["census_soc2010"]=out["soc_code"].str.extract(r"(\\d{2}-\\d{4})",expand=False)
        out=out.dropna(subset=["census_soc2010"])[["OCC2010","census_title","census_soc2010"]].drop_duplicates()
        return out, CENSUS2010_FALLBACK_CSV

def descendants(code, available):
    if code in available:
        return [code]
    major,detail=code.split("-")
    trailing=len(detail)-len(detail.rstrip("0"))
    if trailing==0:
        return []
    prefix=major+"-"+detail[:-trailing]
    return sorted([s for s in available if s.startswith(prefix)])

def map_census(census,soc2010):
    score_cols=["computer_mediated","physical_dependence","relational_public",
                "remote_feasibility_proxy","partial_market_shelter_proxy"]
    score=soc2010.set_index("soc2010")
    available=set(score.index)
    rows=[]
    for (occ,title),g in census.groupby(["OCC2010","census_title"],dropna=False):
        targets=sorted(g.census_soc2010.unique())
        expanded=[]
        for t in targets:
            expanded.extend(descendants(t,available))
        expanded=sorted(set(expanded))
        vals=score.loc[expanded] if expanded else pd.DataFrame(columns=score.columns)
        row={"OCC2010":int(occ),"census_title":title,
             "n_census_soc_targets":len(targets),
             "n_soc2010_scored":len(expanded),
             "crosswalk_ambiguous":bool(len(targets)>1 or any(t not in available for t in targets))}
        for c in score_cols:
            row[c]=pd.to_numeric(vals[c],errors="coerce").mean() if len(vals) else np.nan
        if len(vals):
            row["n_soc2000_sources"]=int(pd.to_numeric(vals["n_soc2000_sources"],errors="coerce").sum())
        else:
            row["n_soc2000_sources"]=0
        rows.append(row)
    return pd.DataFrame(rows).sort_values("OCC2010")

def merge_stage2(path: Path, exposure: pd.DataFrame):
    d=pd.read_csv(path,low_memory=False)
    if "OCC2010" not in d.columns:
        raise RuntimeError("Stage 2 file has no OCC2010 column")
    d["OCC2010"]=pd.to_numeric(d["OCC2010"],errors="coerce")
    d=d[d["OCC2010"].notna()].copy()
    d["OCC2010"]=d["OCC2010"].astype(int)
    return d.merge(exposure,on="OCC2010",how="left",validate="many_to_one")

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--stage2",default="data/derived/ipums_stage2/occupation_geographic_concentration.csv")
    ap.add_argument("--outdir",default="outputs/onet_exposure")
    a=ap.parse_args()
    out=Path(a.outdir); out.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix="onet_exposure_"))
    try:
        bundle=work/"onet.tar.gz"; get(ONET_BUNDLE,bundle)
        root=extract_onet4(bundle,work/"bundle")
        wide,by2000,itemqa=build_onet_scores(root)
        xls=work/"soc_2000_to_2010.xls"; bls_transport=get_any(BLS_SOC_URLS,xls)
        cw=read_bls_2000_2010(xls)
        if len(cw) < 800:
            raise RuntimeError(f"SOC crosswalk structure check failed: only {len(cw)} unique links")
        soc10=build_soc2010(by2000,cw)
        census,census_transport=parse_census2010()
        occ=map_census(census,soc10)

        scorecols=["computer_mediated","physical_dependence","relational_public",
                   "remote_feasibility_proxy","partial_market_shelter_proxy"]
        wide.to_csv(out/"onet40_data_level_scores.csv",index=False)
        by2000.to_csv(out/"soc2000_onet_scores.csv",index=False)
        cw.to_csv(out/"bls_soc2000_to_soc2010_crosswalk.csv",index=False)
        soc10.to_csv(out/"soc2010_onet_scores.csv",index=False)
        census.to_csv(out/"bls_census2010_to_soc2010_crosswalk.csv",index=False)
        occ.to_csv(out/"occ2010_onet_exposures.csv",index=False)
        itemqa.to_csv(out/"frozen_item_coverage.csv",index=False)

        panel=merge_stage2(Path(a.stage2),occ)
        panel.to_csv(out/"occupation_year_exposure_panel.csv",index=False)

        coverage={
          "onet_data_level_occupations":int(wide.onet_soc2000.nunique()),
          "soc2000_scored":int(by2000.soc2000.nunique()),
          "soc2010_scored":int(soc10.soc2010.nunique()),
          "census_occ2010_rows":int(len(occ)),
          "census_occ2010_all_components":int(occ[scorecols].notna().all(axis=1).sum()),
          "stage2_occ2010_rows":int(len(panel)),
          "stage2_rows_with_all_components":int(panel[scorecols].notna().all(axis=1).sum()),
          "rules":"docs/onet_exposure_freeze_v0.md",
          "bls_soc_crosswalk_transport":bls_transport,
          "bls_soc_crosswalk_canonical":BLS_SOC_URLS[0],
          "bls_soc_crosswalk_mirror_commit":"sidsatya/ailabor@9ba422152072e900899f4acd84d95575422af29f",\n          "census2010_crosswalk_transport":census_transport,\n          "census2010_crosswalk_canonical":BLS_CENSUS_HTML,\n          "census2010_crosswalk_fallback_commit":"lowmason/agent-skills@617f5c663ae2a586fd03f0893f36d58864469022",
          "treatment_effects_estimated":False
        }
        (out/"qa.json").write_text(json.dumps(coverage,indent=2))
        print(json.dumps(coverage,indent=2))
    finally:
        shutil.rmtree(work,ignore_errors=True)

if __name__=="__main__":
    main()
