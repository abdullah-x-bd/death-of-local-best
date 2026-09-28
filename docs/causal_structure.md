# Causal structure and estimands

## 1. Why a DAG is necessary

The central empirical problem is not estimating correlations between internet access and occupations. Both technology deployment and local labor-market structure are chosen or evolve endogenously.

The paper therefore distinguishes treatment, moderators, mediators, outcomes, and confounders explicitly.

## 2. Wave 1 Module A: remote labor tradability

### Core causal variables

B_at:
local broadband/connectivity treatment in area a at time t.

T_o:
predetermined occupation-level remote tradability/offshorability.

Y_aot:
occupation-level local labor-market outcome.

U_at:
unobserved or imperfectly observed local economic shocks.

### Simplified causal graph

U_at -> B_at
U_at -> Y_aot

T_o -> baseline occupational geography
B_at × T_o -> effective geographic competition -> Y_aot

National occupation shocks -> Y_aot
Persistent area×occupation specialization -> Y_aot

### Main estimand

The primary object is not the average effect of broadband on all employment.

It is the differential causal response to broadband as a function of predetermined occupation tradability:

d²E[Y_aot] / dB_at dT_o

This is interpretable as a heterogeneous treatment effect only under the identifying assumption that, conditional on the fixed-effects structure and design, unobserved local shocks do not differentially affect occupations according to T_o in ways correlated with B_at.

## 3. Fixed-effects design

Main candidate:

Y_aot = beta(B_at × T_o)
        + alpha_ao
        + lambda_at
        + delta_ot
        + epsilon_aot

alpha_ao:
persistent area×occupation differences.

lambda_at:
all area-wide shocks in a year.

delta_ot:
all national occupation-specific shocks in a year.

This design absorbs the main effects B_at and T_o.

### Remaining threat

A local shock may both accelerate broadband and disproportionately affect high-T_o occupations.

Example:

a local technology boom could induce broadband buildout and raise demand for programmers, writers, designers, and analysts simultaneously.

The high-dimensional fixed effects alone do not eliminate this threat.

Therefore causal interpretation requires at least one of:

- quasi-exogenous broadband supply variation
- convincing dynamic pre-trend evidence plus negative controls and sensitivity analysis
- a policy or infrastructure shock with a defensible exclusion restriction

## 4. Mediators that should not be controlled away

Potential post-treatment mediators include:

- firm entry
- outsourcing
- remote-work adoption
- worker migration
- industry composition
- local platform participation
- occupational switching

These may be mechanisms through which broadband affects outcomes.

Including them as controls in the primary specification would change the estimand and can create post-treatment bias.

They should be analyzed as outcomes or mechanism variables.

## 5. Residence versus workplace geography

Census/ACS PUMS geography refers primarily to residence.

The treatment may affect:

- jobs located in the area
- workers residing in the area
- commuting
- migration

A residence-based decline in occupation share can therefore arise even if jobs remain nearby but workers relocate.

The paper must state that the microdata estimand is initially a resident labor-force outcome unless a place-of-work geography can be constructed consistently.

Where possible, migration and place-of-work information will be used to distinguish:

- local job disappearance
- residential sorting
- commuting changes
- migration

## 6. Module B: scalable output/platform competition

The causal graph differs.

P_at:
local entry/exposure to a digital platform or scalable distribution technology.

I_j:
pre-treatment reliance of local intermediary j on the revenue/product category exposed to the platform.

P_at × I_j -> intermediary revenue shock -> staffing/resources -> worker outcomes

Possible worker outcomes:

- occupation presence
- employment
- self-employment
- migration
- industry switching
- earnings

Craigslist is a candidate because entry is staggered and pre-existing newspaper reliance on classified advertising supplies treatment heterogeneity.

The platform treatment should not be described as generic broadband.

## 7. Wave 2: generative AI

A_o:
predetermined AI exposure of occupation o.

D_o:
digital tradability of occupation o.

Post_t:
post-generative-AI period indicator.

A simple observational interaction:

A_o × D_o × Post_t

does not by itself identify a causal AI effect because AI exposure is correlated with education, industry, occupation trends, and task structure.

Primary AI causal claims should therefore come from randomized or credible quasi-experimental mechanism evidence.

Original aggregate labor-market estimates remain exploratory unless a cleaner shock is identified.

## 8. Target causal language

Use "causes" only when the design supports a causal estimand under stated assumptions.

Use "is associated with" for descriptive regressions.

Use "consistent with the mechanism" where evidence matches predictions but does not identify the causal pathway.

Use "suggests" only with the specific uncertainty made explicit.

## 9. Failure conditions

The preferred local-scarcity interpretation should be weakened or rejected if:

- high-tradability occupations trend differently before broadband treatment
- comparable patterns occur in low-tradability negative controls
- results depend on one treatment definition created by a reporting discontinuity
- geographic concentration rises but occupation presence does not change in a way consistent with the theory
- migration fully explains apparent local disappearance without a labor-market loss
- alternative exposure measures reverse the main result
- treatment effects are driven by one occupation or one state
- a plausible confounder generates the same pattern in placebo periods

A null result on any one outcome is not automatically fatal because the theory distinguishes reallocation, concentration, and destruction. But the interpretation must follow the observed margin rather than the preferred narrative.
