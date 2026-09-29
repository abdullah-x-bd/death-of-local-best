# Confirmatory Analysis Plan v0.1

Status: draft for design review. Not yet frozen.

## Rule

No primary outcome model will be estimated on the final field-analysis dataset until:
- treatment definitions are frozen
- occupation crosswalks are frozen
- geographic crosswalks are frozen
- primary outcomes are frozen
- exclusion rules are frozen
- code implementing these choices is committed

Exploratory analyses will be clearly separated.

## Confirmatory claim family A: randomized marketplace

A1. Market integration reduces the revenue share of pre-treatment middle-skill producers when output is scalable.

A2. Capacity constraints attenuate the integration effect.

A3. Integration increases concentration among scalable producers.

A4. AI entry reduces human market share and continuation, conditional on a fixed buyer budget.

Primary estimands and models are specified in experiments/market_integration_ai_rct.md.

## Confirmatory claim family B: broadband field design

### Primary unit
geography × occupation × year

### Preferred geography
commuting zone or harmonized metropolitan area

### Primary treatment
quasi-exogenous broadband expansion from BIP/BTOP funding or a stronger near-cutoff design if recoverable application scores permit it.

### Treatment modifier
pre-treatment occupation tradability/scalability index.

### Pre-treatment local advantage
measured only using data before treatment.

Candidate measure:
location quotient or local share of national occupation employment averaged over a fixed pre-period.

### Primary outcomes

B1. Local occupation employment share.

B2. Share of national occupation employment located in ordinary versus top producer locations.

B3. Real median earnings from IPUMS microdata.

B4. Occupational participation/entry among young workers where sample size permits.

### Main specification

Y_got =
  alpha_go
  + gamma_gt
  + delta_ot
  + beta1 Treatment_gt × Tradability_o
  + beta2 Treatment_gt × Tradability_o × PreLocalAdvantage_go
  + error_got

Fixed effects:
- geography × occupation
- geography × year
- occupation × year

Inference:
- cluster at treatment-assignment geography
- report randomization inference where assignment mechanism can be reconstructed
- otherwise report cluster-robust and wild-cluster bootstrap inference

### Required diagnostics

- event-study leads jointly indistinguishable from zero
- no treatment prediction by pre-treatment outcome trends
- no effects in negative-control occupations requiring physical presence
- robustness to excluding top technology metros
- robustness to alternative occupation crosswalks
- robustness to population weighting and unweighted estimates

## Confirmatory claim family C: generative AI second shock

### Treatment timing
Late 2022 is the event boundary.

### Treatment intensity
At least three independently constructed pre-treatment exposure measures.

Primary exposure must be frozen without examining post-2022 labor outcomes.

Preferred hierarchy:
1. historical task-based human-coded substitutability index
2. established published GenAI exposure index
3. alternative published exposure index

LLM-generated exposure scores are never used as the sole primary measure.

### Primary outcomes

C1. vacancy postings, if Lightcast/Revelio data obtained

C2. employment and earnings in CPS/ACS/IPUMS

C3. self-employment or nonemployer establishment activity where mapping is credible

C4. entry-level versus experienced-worker demand if job-posting data permit

### Main event-study logic

Outcome_o,g,t =
  fixed effects
  + sum_k beta_k [Exposure_o × 1(event time = k)]
  + error

Required:
- multiple pre-treatment years
- pre-trend equivalence
- exclusion of pandemic-transition years in robustness checks
- controls for interest-rate-sensitive occupation structure where possible
- alternative event boundaries around major model releases

### Strong causal upgrade

If actual firm/platform AI-adoption dates become available:
- replace exposure-only design with staggered adoption
- use not-yet-treated controls
- estimate adoption × pre-treatment substitutability heterogeneity
- test for treatment pre-trends

## Multiple testing

Primary hypotheses are grouped into:
- randomized mechanism family
- broadband field family
- AI field family

Within each family:
- Holm correction for primary outcomes
- unadjusted estimates shown alongside adjusted p-values
- all secondary outcomes explicitly labeled secondary

## Missing data

No imputation of employment cells suppressed by source agencies in the primary analysis.

Alternative bounds/suppression treatments may appear only as robustness analyses.

## Crosswalk uncertainty

Where occupation or geography mapping is one-to-many:
- primary crosswalk rule selected without outcome information
- ambiguous mappings flagged
- robustness repeated under alternative admissible mappings
- results for unstable occupations separately reported

## Stopping rules

Field analyses use the full prespecified dataset.

Experimental sample size is fixed by pilot-based power simulation before confirmatory recruitment.

No optional stopping based on treatment significance.

## Interpretation rule

The complete market-shelter claim will not be declared supported from one statistically significant coefficient.

The paper requires sign-consistent evidence across:
- randomized mechanism
- broadband field shock
- AI second shock

Contradictory evidence will be reported and the scope of the theory narrowed accordingly.
