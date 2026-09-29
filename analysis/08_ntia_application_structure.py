#!/usr/bin/env python3
from __future__ import annotations
import argparse, json, re
from pathlib import Path
import pandas as pd, requests

URL="https://web.archive.org/web/20110429013531id_/http://www.ntia.doc.gov/broadbandgrants/applications/Comprehensive_Query_Results.xls"
UA="death-of-local-best-research/0.3"

def clean_id(s):
    x=str(s).strip()
    return re.sub(r"\.0$","",x)

def num(s):
    return pd.to_numeric(s,errors="coerce")

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--outdir",default="data/derived/ntia_applications")
    a=ap.parse_args()
    out=Path(a.outdir); out.mkdir(parents=True,exist_ok=True)
    raw=out/"_applications.xls"
    r=requests.get(URL,headers={"User-Agent":UA},timeout=120)
    r.raise_for_status()
    raw.write_bytes(r.content)

    s1=pd.read_excel(raw,sheet_name="Sheet1",dtype=str)
    s2=pd.read_excel(raw,sheet_name="Sheet2",dtype=str)
    s3=pd.read_excel(raw,sheet_name="Sheet3",dtype=str)

    # Sanitized application master. No personal contact fields are persisted.
    keep=[
      "Project - Easygrants ID","Organization - Legal Name","Project - Title",
      "RBI - Non-Infrastructure Project Type","RBI - Rural Classificaton",
      "RBI - BIP - Last Mile Remote Area","RBI - BIP with BTOP Consideration",
      "BTOP Infrastructure Category Consideration",
      "Non-Rural BTOP Infrastructure Category Consideration",
      "RBI - Infrastructure - Total Project Budget","RBI - Grant Request",
      "RBI - Loan Request","Project - Program","Project Type","Classification",
      "Project - Description","Project - Funding Cycle",
      "Organization - Primary Address State/Province","Tasks - Outcome",
      "Grant Award","Loan Award","Other Funding","Funding Round Number"
    ]
    keep=[c for c in keep if c in s1.columns]
    master=s1[keep].copy()
    master=master.rename(columns={"Project - Easygrants ID":"easygrants_id"})
    master["easygrants_id"]=master["easygrants_id"].map(clean_id)

    for c in ["Grant Award","Loan Award","Other Funding","RBI - Grant Request","RBI - Loan Request",
              "RBI - Infrastructure - Total Project Budget"]:
        if c in master:
            master[c+"_numeric"]=num(master[c])

    award_cols=[c+"_numeric" for c in ["Grant Award","Loan Award","Other Funding"] if c in master]
    if award_cols:
        master["positive_award_amount_candidate"]=master[award_cols].fillna(0).sum(axis=1)>0

    # State rows by application.
    s2.columns=[str(c).strip() for c in s2.columns]
    id2=next(c for c in s2.columns if "Easygrants" in c)
    state2=next(c for c in s2.columns if "State" in c)
    states=s2[[id2,state2]].copy()
    states.columns=["easygrants_id","project_state"]
    states["easygrants_id"]=states["easygrants_id"].map(clean_id)
    states["project_state"]=states["project_state"].map(lambda v: "" if pd.isna(v) else str(v).strip())
    states=states[(states.easygrants_id!="nan")&(states.project_state!="")].drop_duplicates()
    state_summary=states.groupby("easygrants_id").agg(
        n_project_states=("project_state","nunique"),
        project_states=("project_state",lambda x:"|".join(sorted(set(x))))
    ).reset_index()

    # Sheet3 project-area field, kept verbatim because its semantics need auditing.
    s3.columns=[str(c).strip() for c in s3.columns]
    id3=next(c for c in s3.columns if c.upper()=="EGID" or "Easygrants" in c)
    area3=next(c for c in s3.columns if "Project Area" in c)
    areas=s3[[id3,area3]].copy()
    areas.columns=["easygrants_id","project_area"]
    areas["easygrants_id"]=areas["easygrants_id"].map(clean_id)
    areas["project_area"]=areas["project_area"].astype(str).str.strip()
    areas=areas[(areas.easygrants_id!="nan")&(areas.project_area!="nan")].drop_duplicates()

    merged=master.merge(state_summary,on="easygrants_id",how="left",validate="one_to_one")
    merged=merged.merge(areas,on="easygrants_id",how="left",validate="one_to_one")

    # Profiles for potential status/classification variables, without assigning treatment.
    profile_cols=[
      "Project - Program","Project Type","Classification","Project - Funding Cycle",
      "Tasks - Outcome","Funding Round Number","RBI - Rural Classificaton",
      "RBI - BIP - Last Mile Remote Area","RBI - BIP with BTOP Consideration",
      "BTOP Infrastructure Category Consideration",
      "Non-Rural BTOP Infrastructure Category Consideration",
      "positive_award_amount_candidate","project_area","n_project_states"
    ]
    prof=[]
    for c in profile_cols:
        if c not in merged: continue
        vc=merged[c].fillna("<NA>").astype(str).str.strip().value_counts(dropna=False)
        for v,n in vc.items():
            prof.append({"column":c,"value":v,"count":int(n)})
    pd.DataFrame(prof).to_csv(out/"application_field_profiles.csv",index=False)

    # Project-area shape diagnostics.
    av=areas.project_area
    diag={
      "applications_rows":int(len(master)),
      "unique_application_ids":int(master.easygrants_id.nunique()),
      "state_rows":int(len(states)),
      "applications_with_state_rows":int(states.easygrants_id.nunique()),
      "project_area_rows":int(len(areas)),
      "applications_with_project_area":int(areas.easygrants_id.nunique()),
      "project_area_unique_values":int(av.nunique()),
      "project_area_examples":av.value_counts().head(40).index.tolist(),
      "positive_award_amount_candidate_count":int(merged.get("positive_award_amount_candidate",pd.Series(False,index=merged.index)).fillna(False).sum()),
      "treatment_status_frozen":False,
      "note":"positive_award_amount_candidate is diagnostic only until validated against official award records/status."
    }
    (out/"structure_qa.json").write_text(json.dumps(diag,indent=2))

    # Public government source, but minimize persisted columns and personal information.
    merged.to_csv(out/"application_master_sanitized.csv",index=False)
    states.to_csv(out/"application_project_states.csv",index=False)
    areas.to_csv(out/"application_project_area.csv",index=False)

    # Remove raw workbook from derived directory before commit.
    raw.unlink()
    print(json.dumps(diag,indent=2))

if __name__=="__main__":
    main()
