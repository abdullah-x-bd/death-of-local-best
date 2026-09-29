# From Local Scarcity to Machine Abundance

**Digital Markets and the Erosion of Competence Rents**

This repository contains the reproducible research workflow for a paper studying how successive technologies alter the economic value of locally scarce human competence.

## Core research question

Did digital market integration erode geographic market shelter for occupations whose outputs can travel over distance, and does generative AI represent a second shock by reducing the scarcity of competent cognitive output itself?

## Target causal claim

When technology removes market shelter, economic activity in scalable occupations may shift toward a smaller set of producers and places, reducing the viability of middle-tier local producers even when aggregate output or national employment does not fall. Generative AI may create a second shock by reducing the amount of human labor required for competent cognitive production.

This claim is treated as a hypothesis until the prespecified causal tests are completed.

## Causal architecture

The project uses triangulation rather than relying on one observational regression.

1. **Randomized marketplace experiment**
   Randomizes market integration, producer capacity/scalability, and an AI outside option.

2. **Broadband field quasi-experiment**
   Tests whether real broadband expansion reallocates digitally tradable occupations across local labor markets in the heterogeneous pattern predicted by the experiment.

3. **Institutional digital-entry shocks**
   Uses settings such as staggered Craigslist entry to test the destruction of local intermediating revenue channels.

4. **Generative-AI second shock**
   Tests whether post-2022 labor-market changes follow pre-treatment AI substitutability and digital tradability, ideally upgraded with actual firm/platform AI adoption data.

## Epistemic structure

The project separates claims into four categories:

1. **Descriptive facts** documented directly from harmonized data.
2. **Causal estimates** supported by randomization or explicit quasi-experimental identification.
3. **Mechanism evidence** supported by randomized treatment or independent field shocks.
4. **Hypotheses and extrapolations** labeled as such.

No descriptive association will be presented as causal evidence.

## Key design documents

- `docs/causal_architecture.md`
- `docs/identification.md`
- `docs/measurement_market_shelter.md`
- `docs/threat_matrix.md`
- `experiments/market_integration_ai_rct.md`
- `preregistration/analysis_plan.md`
- `docs/data_provenance.md`
- `docs/decision_log.md`
- `analysis/power_market_experiment.R`

## Reproducibility

The analysis is being built in R with scripted data acquisition, deterministic crosswalks, explicit decision logs, versioned dependencies, and prespecified primary specifications.

Raw restricted or licensed data will not be committed publicly. Provenance, hashes, transformation code, and synthetic fixtures will be versioned.

## Current status

The causal architecture is under design review.

Primary outcome regressions are intentionally deferred until:
- treatment definitions are frozen
- occupation and geography harmonization rules are frozen
- the market-shelter measurement protocol is frozen
- primary outcomes and exclusion rules are preregistered

This is deliberate. The repository is being structured so that the empirical results cannot determine the research design after the fact.
