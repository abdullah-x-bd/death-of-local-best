# Analysis plan v0.1

Status: design-stage working document. Headline outcome regressions have not been run.

Date opened: 2026-09-28

## 1. Main question

Does digital market integration reduce the local economic protection of occupations whose outputs are more digitally tradable?

## 2. Secondary question

Does generative AI plausibly constitute a second technological shock by reducing the scarcity of competent cognitive output, particularly in occupations already exposed to global digital competition?

## 3. Primary Wave 1 hypothesis

H1: Greater local broadband availability causes a larger change in the local labor-market position of more digitally tradable occupations than of less digitally tradable occupations.

The sign is not prespecified for every outcome. The theory makes sharper predictions for geographic presence and concentration than for total national employment.

## 4. Primary outcomes

The final primary set will contain no more than three outcomes.

Provisional primary outcomes:

1. occupation present in local labor market
2. occupation employment share of local employment
3. real median earnings within occupation × geography

## 5. Secondary outcomes

- occupation employment count
- geographic HHI
- self-employment share
- entry among workers aged 22 to 30
- migration status
- real mean earnings
- P90/P50
- P50/P10
- institutional employment share where definable

## 6. Main sample

Target period will be determined by overlap of harmonized occupational microdata and credible broadband data.

ACS 1-year PUMS is available for 2005-2019 and 2021-2024. The standard 2020 1-year ACS is not treated as interchangeable with adjacent years.

A CPS replication may extend the temporal window but will not be used to silently replace the ACS result if it disagrees.

## 7. Treatment

Primary treatment: predetermined local broadband availability measure.

Candidate datasets:

- NTIA State Broadband Initiative archive
- FCC Form 477 fixed broadband deployment data
- other historical supply-side broadband measures if a defensible pre-period can be constructed

Treatment definitions will be documented before outcome regression selection.

## 8. Moderator

Primary moderator: continuous occupation-level digital tradability score constructed from predetermined characteristics or adopted from published literature.

The construction algorithm will be frozen before headline outcome models are estimated.

## 9. Main model

Y_aot = beta(Broadband_at × Tradability_o)
        + FE_area×occupation
        + FE_area×year
        + FE_occupation×year
        + epsilon_aot

Standard errors will be clustered at a level justified by treatment assignment and residual correlation. Spatial sensitivity will be assessed where feasible.

## 10. Weighting

The primary weighting scheme will be chosen before estimation.

Possible choices:

- unweighted area × occupation cells for an average-local-market estimand
- population or baseline-employment weighting for an average-worker estimand

Because these answer different questions, one will be primary and the other reported as sensitivity rather than selected based on significance.

## 11. Event study

If treatment timing is meaningfully staggered, use a modern staggered-adoption estimator.

Report all available leads and lags consistent with support.

No binning choice will be made solely to improve visual pre-trends.

## 12. Parallel-trends sensitivity

Required:

- visual pre-trends
- joint pre-period summary
- effect-size comparison of pre-trends to post effects
- formal sensitivity analysis when feasible

Failure to reject a pre-trend test is not sufficient evidence of parallel trends.

## 13. Multiple testing

Headline claims will be restricted to prespecified primary estimands.

Secondary outcome families will be reported completely. Where a family contains many related outcomes, false-discovery or family-wise adjustments will be considered.

## 14. Sample exclusions

No observation will be excluded because it weakens the result.

Potential ex ante exclusions to evaluate:

- cells below disclosure or reliability thresholds
- geographies that cannot be harmonized consistently
- occupation codes without defensible crosswalks
- years where the underlying survey or classification is non-comparable

All exclusions will be recorded.

## 15. COVID

2020-2021 may create exceptional labor-market dynamics.

Primary strategy to be decided before headline estimation. Candidate approach:

- estimate core Wave 1 results on pre-COVID period
- report later years separately
- do not use COVID exclusions selectively by outcome

## 16. Recession sensitivity

The Great Recession may differentially affect media and creative industries.

Required robustness:

- models with 2008-2010 included
- models excluding the recession window
- occupation × year fixed effects in the main design

## 17. Superstar-city sensitivity

Results will be checked after excluding the largest creative and technology hubs.

The exact rule for identifying these metros will be prespecified.

## 18. Leave-one-out analysis

For aggregate occupation-group findings:

- leave one occupation out
- leave one state or large geography out

This checks whether a result is carried by a single obvious category or region.

## 19. Wave 2

Primary AI claims will be mechanism claims grounded in experiments or strong quasi-experiments.

Any original post-2022 analysis in this repository will initially be labeled exploratory.

If a credible identification design is later established, the analysis plan will be versioned and the change timestamped before estimation.

## 20. Deviations

Any departure from this document after headline analysis begins must be logged in docs/deviations_from_plan.md with date, change, reason, whether the relevant result had already been observed, and consequences for confirmatory versus exploratory status.

## 21. Two distinct first-wave mechanisms

The original intuition contains two mechanisms that must not be conflated.

### Module A: remote tradability of labor

Question: does broadband reduce geographic protection for occupations whose work can be supplied from elsewhere?

Primary moderator candidates: Blinder/Blinder-Krueger offshorability and related predetermined measures.

Natural outcomes: local occupation presence, local employment share, wages, migration, occupational entry.

### Module B: scalable digital output and attention

Question: does digital distribution allow a small number of producers or products to serve much larger audiences, weakening local demand for replicated cultural/information output?

This mechanism is closer to Rosen-style superstar technology and cannot be proxied adequately by offshorability alone.

Candidate settings require separate data and identification. Possibilities include recorded music, newspapers/local media, photography/media products, publishing, and other outputs with low marginal reproduction costs.

Module B will not be merged into Module A merely to obtain one headline coefficient.

Any common conclusion across the modules must be supported independently by each design.
