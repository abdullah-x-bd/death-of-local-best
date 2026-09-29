#!/usr/bin/env python3
"""
Synthetic end-to-end dry run for the randomized marketplace experiment.

Purpose:
- validate randomization and data schemas
- validate segmented vs integrated choice sets
- validate capacity enforcement and AI availability
- compute all four primary outcomes
- test analysis plumbing

NOT PURPOSE:
- estimate a scientific effect
- choose the confirmatory sample size
- tune treatment parameters to produce significance
"""
from __future__ import annotations
import argparse, json, math
from itertools import product
from pathlib import Path
import numpy as np
import pandas as pd

CELLS=list(product([0,1],[0,1],[0,1]))

def softmax(x):
    z=x-np.max(x)
    e=np.exp(z)
    return e/e.sum()

def gini(x):
    x=np.asarray(x,dtype=float)
    if x.size==0 or np.allclose(x.sum(),0): return 0.0
    x=np.sort(np.maximum(x,0))
    n=len(x)
    return (2*np.sum((np.arange(1,n+1))*x)/(n*x.sum()))-(n+1)/n

def build_clusters(cfg,rng,blocks):
    rows=[]
    task_fams=cfg["task_families"]
    for b in range(blocks):
        perm=rng.permutation(len(CELLS))
        task=task_fams[b%len(task_fams)]
        for slot,cell_idx in enumerate(perm):
            integ,scal,ai=CELLS[cell_idx]
            cid=f"B{b:03d}_M{slot:02d}"
            # Pre-treatment producer ability exists before assignment.
            latent=rng.normal(0,1,cfg["roles"]["producers_per_cluster"])
            rows.append({
                "block":b,"cluster_id":cid,"task_family":task,
                "integrated":integ,"scalable":scal,"ai":ai,
                "pre_skill_mean_latent":latent.mean(),
                "pre_skill_sd_latent":latent.std(ddof=1),
                "_latent":latent
            })
    return rows

def benchmark_producers(cluster,cfg,rng):
    n=cfg["roles"]["producers_per_cluster"]
    latent=cluster["_latent"]
    rec=[]
    for i in range(n):
        ratings=latent[i]+rng.normal(0,0.45,cfg["benchmark_raters_per_output"])
        score=ratings.mean()
        rec.append({
            "cluster_id":cluster["cluster_id"],
            "producer_id":f'{cluster["cluster_id"]}_P{i:03d}',
            "producer_index":i,
            "benchmark_score":score,
            "latent_quality":latent[i]
        })
    p=pd.DataFrame(rec)
    # Quintiles are assigned within the full randomized cluster bundle for dry-run.
    p["skill_quintile"]=pd.qcut(
        p["benchmark_score"].rank(method="first"),
        5,labels=[1,2,3,4,5]
    ).astype(int)
    return p

def choice_set_indices(cfg,integrated,buyer_idx):
    nprod=cfg["roles"]["producers_per_cluster"]
    if integrated:
        return np.arange(nprod)
    sub=buyer_idx//50
    return np.arange(sub*10,(sub+1)*10)

def simulate_round(cluster,producers,cfg,rng,round_no):
    integ=cluster["integrated"]; scalable=cluster["scalable"]; ai=cluster["ai"]
    nb=cfg["roles"]["buyers_per_cluster"]
    if round_no<=4:
        prices=np.full(len(producers),cfg["human_fixed_price_dry_run"])
    else:
        lo,hi=cfg["price_bounds_dry_run"]
        raw=1.0+0.08*producers["benchmark_score"].to_numpy()+rng.normal(0,0.08,len(producers))
        prices=np.clip(raw,lo,hi)

    remaining=np.full(len(producers),10**9 if scalable else cfg["capacity_k_dry_run"],dtype=int)
    purchases=np.zeros(len(producers),dtype=int)
    buyer_rows=[]
    order=rng.permutation(nb)
    for buyer in order:
        avail=choice_set_indices(cfg,integ,buyer)
        avail=avail[remaining[avail]>0]
        human_utils=np.array([])
        if len(avail):
            q=producers.iloc[avail]["latent_quality"].to_numpy()
            taste=rng.normal(0,0.45,len(avail))
            human_utils=q-prices[avail]+taste
        labels=[("human",int(j)) for j in avail]
        utils=list(human_utils)

        if ai:
            ai_quality=0.0
            ai_u=ai_quality-cfg["ai_price_dry_run"]+rng.normal(0,0.45)
            labels.append(("ai",-1)); utils.append(ai_u)

        # Prespecified no-purchase outside option.
        labels.append(("outside",-1)); utils.append(-0.25+rng.normal(0,0.20))

        pr=softmax(np.array(utils))
        k=int(rng.choice(len(labels),p=pr))
        kind,idx=labels[k]
        paid=0.0; quality=0.0
        if kind=="human":
            purchases[idx]+=1; remaining[idx]-=1
            paid=float(prices[idx]); quality=float(producers.iloc[idx]["latent_quality"])
        elif kind=="ai":
            paid=float(cfg["ai_price_dry_run"]); quality=0.0
        buyer_rows.append({
            "cluster_id":cluster["cluster_id"],"round":round_no,"buyer_index":int(buyer),
            "choice_type":kind,"producer_index":idx,"price":paid,"quality":quality,
            "buyer_surplus":quality-paid
        })

    prod=producers[["cluster_id","producer_id","producer_index","benchmark_score","skill_quintile"]].copy()
    prod["round"]=round_no
    prod["price"]=prices
    prod["units"]=purchases
    prod["revenue"]=prices*purchases
    return prod,pd.DataFrame(buyer_rows)

def primary_outcomes(cluster,producers,prod_rounds,buyers,continuation):
    rev=prod_rounds.groupby("producer_index",as_index=False)["revenue"].sum()
    p=producers.merge(rev,on="producer_index",how="left").fillna({"revenue":0})
    total=p["revenue"].sum()
    middle=p["skill_quintile"].between(2,4)
    middle_share=p.loc[middle,"revenue"].sum()/total if total>0 else np.nan

    top_n=max(1,math.ceil(0.10*len(p)))
    top_share=p.nlargest(top_n,"revenue")["revenue"].sum()/total if total>0 else np.nan

    mid_cont=continuation.loc[continuation["skill_quintile"].between(2,4),"continued"].mean()
    buyer_surplus=buyers["buyer_surplus"].mean()
    return {
        "cluster_id":cluster["cluster_id"],
        "task_family":cluster["task_family"],
        "integrated":cluster["integrated"],
        "scalable":cluster["scalable"],
        "ai":cluster["ai"],
        "MiddleSkillRevenueShare":middle_share,
        "Top10RevenueShare":top_share,
        "MiddleSkillContinuation":mid_cont,
        "BuyerQualityAdjustedSurplus":buyer_surplus,
        "RevenueGini_secondary":gini(p["revenue"]),
        "ZeroRevenueShare_secondary":float((p["revenue"]==0).mean()),
        "AIPurchaseShare_secondary":float((buyers["choice_type"]=="ai").mean())
    }

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--config",required=True)
    ap.add_argument("--outdir",default="outputs/market_experiment_dry_run")
    ap.add_argument("--blocks",type=int,default=3,
                    help="Dry-run blocks. Each block contains all 8 factorial cells.")
    a=ap.parse_args()
    cfg=json.loads(Path(a.config).read_text())
    out=Path(a.outdir); out.mkdir(parents=True,exist_ok=True)
    rng=np.random.default_rng(cfg["dry_run_seed"])

    clusters=build_clusters(cfg,rng,a.blocks)
    assignment=pd.DataFrame([{k:v for k,v in c.items() if k!="_latent"} for c in clusters])
    assignment.to_csv(out/"cluster_randomization.csv",index=False)

    # Design invariant: every block has exactly one of all 8 cells.
    counts=assignment.groupby(["block","integrated","scalable","ai"]).size()
    assert (counts==1).all() and len(counts)==a.blocks*8
    assert (cfg["roles"]["buyers_per_cluster"]/cfg["roles"]["producers_per_cluster"])==5

    all_prod=[]; all_buy=[]; all_cont=[]; outcomes=[]
    for c in clusters:
        p=benchmark_producers(c,cfg,rng)
        prs=[]; brs=[]
        for r in range(1,9):
            pr,br=simulate_round(c,p,cfg,rng,r)
            prs.append(pr); brs.append(br)
        pr=pd.concat(prs,ignore_index=True)
        br=pd.concat(brs,ignore_index=True)

        revenue=pr.groupby("producer_index")["revenue"].sum()
        cont=p[["cluster_id","producer_id","producer_index","benchmark_score","skill_quintile"]].copy()
        cont["cumulative_revenue"]=cont["producer_index"].map(revenue).fillna(0)
        # Synthetic continuation response. This is not a planned behavioral model.
        z=-0.7+0.025*cont["cumulative_revenue"].to_numpy()+rng.normal(0,0.65,len(cont))
        cont["continued"]=(rng.random(len(cont)) < 1/(1+np.exp(-z))).astype(int)

        outcomes.append(primary_outcomes(c,p,pr,br,cont))
        all_prod.append(pr); all_buy.append(br); all_cont.append(cont)

    outcomes=pd.DataFrame(outcomes)
    outcomes.to_csv(out/"primary_outcomes_by_cluster.csv",index=False)
    pd.concat(all_cont,ignore_index=True).to_csv(out/"continuation_synthetic.csv",index=False)

    # Do not retain full synthetic transaction tables as required evidence.
    # Keep compact manipulation checks only.
    pr=pd.concat(all_prod,ignore_index=True)
    br=pd.concat(all_buy,ignore_index=True)
    cap=pr.groupby(["cluster_id","producer_index"],as_index=False)["units"].max()
    manipulation=pd.DataFrame({
        "check":[
            "factorial_balance_per_block",
            "buyer_seller_ratio_equal",
            "integrated_choice_set_size",
            "segmented_choice_set_size",
            "capacity_upper_bound_enforced"
        ],
        "passed":[
            True,True,
            cfg["roles"]["producers_per_cluster"]==100,
            cfg["roles"]["producers_per_cluster"]//cfg["roles"]["segmented_submarkets_per_cluster"]==10,
            bool((cap.merge(assignment[["cluster_id","scalable"]],on="cluster_id")
                  .query("scalable == 0")["units"] <= cfg["capacity_k_dry_run"]).all())
        ]
    })
    manipulation.to_csv(out/"design_invariants.csv",index=False)
    assert manipulation["passed"].all()

    summary={
        "synthetic_only":True,
        "blocks":a.blocks,
        "clusters":len(clusters),
        "synthetic_producers":len(clusters)*cfg["roles"]["producers_per_cluster"],
        "synthetic_buyers_per_round":len(clusters)*cfg["roles"]["buyers_per_cluster"],
        "factorial_cells":8,
        "all_design_invariants_passed":bool(manipulation["passed"].all()),
        "confirmatory_seed_frozen":False,
        "confirmatory_sample_size_frozen":False,
        "pilot_nuisance_parameters_available":False
    }
    (out/"dry_run_summary.json").write_text(json.dumps(summary,indent=2))
    print(json.dumps(summary,indent=2))

if __name__=="__main__":
    main()
