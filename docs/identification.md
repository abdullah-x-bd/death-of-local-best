# Identification strategy

## 1. Research object

The paper studies whether technologies that lower the cost of accessing or producing competence erode rents that arise because competence is locally scarce.

The empirical program is deliberately split into two technological waves.

**Wave 1** studies digital market integration. The causal object is the effect of greater digital connectivity on labor-market outcomes for occupations whose outputs are more digitally tradable.

**Wave 2** studies generative AI. The paper will not infer an economy-wide causal effect of AI from a simple pre/post 2022 comparison. It will combine credible experimental or quasi-experimental mechanism evidence with carefully labeled early labor-market evidence.

## 2. Conceptual decomposition

For worker or producer i:

R_i = R_i^G + R_i^S + R_i^H

where:

- R^G is geographic scarcity rent
- R^S is skill scarcity rent
- R^H is human-specific or relational rent

The internet is hypothesized to reduce R^G primarily. Generative AI may reduce R^S for tasks where competent output can be machine-produced or strongly machine-augmented.

This decomposition is conceptual. The empirical work does not assume these components are separately observed.

## 3. Wave 1 primary estimand

Let a index geographic areas, o occupations, and t years.

The main reduced-form specification is:

Y_aot = beta (Broadband_at × DigitalTradability_o)
        + alpha_ao + lambda_at + delta_ot + epsilon_aot

where:

- alpha_ao are area × occupation fixed effects
- lambda_at are area × year fixed effects
- delta_ot are occupation × year fixed effects

The identifying comparison is whether occupations with greater predetermined digital tradability change differentially within the same local economy as broadband availability expands.

### Why the fixed effects matter

Area × occupation fixed effects absorb persistent local specialization.

Area × year fixed effects absorb local macroeconomic shocks common across occupations, including local recessions, housing shocks, population growth, and many policy changes.

Occupation × year fixed effects absorb national occupation-specific shocks, including national demand changes and technological trends common across locations.

The coefficient beta therefore does not compare connected places with unconnected places in levels.

## 4. Primary outcomes

Primary outcomes will be frozen before headline estimation.

Candidate primary outcomes:

1. geographic ubiquity or occupational presence
2. local employment share
3. real median earnings

Secondary outcomes:

- employment level
- geographic concentration
- self-employment
- occupational entry among young workers
- migration
- P90/P50 and P50/P10 earnings ratios
- probability that an occupation disappears from a local market
- institutional versus independent employment

## 5. Dynamic specification

A dynamic event-study version will estimate treatment leads and lags rather than rely on one post-treatment coefficient.

The design must show the full pre-period.

No statement of a causal treatment effect will be made solely because pre-treatment coefficients fail to reject zero. Magnitudes and confidence intervals of pre-trends will be inspected.

If treatment timing is staggered, modern cohort-specific estimators will be preferred to an unrestricted conventional two-way fixed-effects event study.

Sensitivity analysis will assess how large deviations from parallel trends would need to be to overturn conclusions.

## 6. Broadband endogeneity

Broadband deployment is not assumed exogenous.

Potential confounders include:

- local income
- education
- population density
- pre-existing industrial composition
- technology-sector growth
- urbanization
- migration
- infrastructure investment
- local demand for broadband

The primary interaction design reduces but does not automatically eliminate these threats.

A separate quasi-experimental or instrumental-variable design will be considered only if a defensible source of supply-side rollout variation is identified.

Any instrument must receive an explicit exclusion-restriction audit. Predetermined does not imply valid.

## 7. Digital tradability

Digital tradability will be defined before outcome regressions.

The index must be based on predetermined occupation characteristics or a published classification rather than retrospective selection of occupations that fit the result.

Candidate dimensions include:

- physical presence requirements
- face-to-face interaction
- manipulation of physical objects
- computer dependence
- remote-work feasibility
- whether the core output can be transmitted electronically
- location-specific customer interaction

The primary specification will use a continuous index.

Binary high/low groupings, if shown, will be used primarily for visualization and robustness.

## 8. Negative controls

The mechanism predicts weaker effects for occupations whose core output cannot be delivered at distance.

Negative-control or low-tradability occupations will be defined ex ante.

Examples may include selected construction trades, personal services, food preparation, physically delivered health services, and repair trades.

The final list will be determined from the same predetermined tradability index used for treated occupations, not manually chosen after results are observed.

## 9. Extensive versus intensive margin

A central prediction concerns disappearance of local occupational niches.

For occupation o at time t:

E_ot = N_ot × mean(E_aot | occupation present)

where N_ot is the number of geographic markets in which the occupation is present.

This allows a distinction between:

- fewer workers everywhere
- complete disappearance from some local markets
- geographic concentration into larger labor markets

The second and third mechanisms are especially relevant to the local-scarcity hypothesis.

## 10. Migration

A decline in local occupational employment does not necessarily imply national occupational destruction.

Workers may move toward large labor markets.

Where data permit, outcomes will distinguish occupational exit, local employment decline, geographic reallocation, migration, and occupational entry.

This distinction is required before describing any estimated effect as destruction rather than reallocation.

## 11. Wave 2 identification

The AI section will distinguish three evidentiary levels.

### Level A: causal mechanism evidence

Randomized experiments and credible workplace deployments can identify productivity and skill-compression mechanisms.

### Level B: quasi-experimental market evidence

Where a platform or labor market has a credible exposure design, the paper can report causal or quasi-causal estimates with the assumptions made explicit.

### Level C: early observational evidence

Occupation-level post-2022 regressions will be described as differential changes consistent or inconsistent with the framework unless treatment assignment is credibly identified.

A proposed secondary specification is:

Y_ot = beta (AIExposure_o × DigitalTradability_o × PostAI_t) + fixed effects + error

This is not automatically causal.

## 12. Falsification philosophy

The project will actively attempt to reject its own preferred explanation.

Required robustness families include:

- placebo treatment dates
- pre-treatment pseudo-events
- low-tradability occupations
- alternative occupation harmonizations
- alternative geographic units
- dropping superstar metros
- dropping recession years
- dropping COVID years
- weighted and unweighted specifications
- alternative broadband thresholds
- balanced-panel restrictions
- leave-one-occupation-out tests
- leave-one-state-out tests
- alternative standard-error structures
- sensitivity to tradability definitions

A result that survives only one convenient specification will not be treated as a core finding.

## 13. Interpretation rule

Every substantive claim in the manuscript must be tagged internally as one of descriptive, causal, mechanism, or hypothesis.

The prose will not move a result into a stronger category than the design permits.
