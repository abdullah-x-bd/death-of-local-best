# Alternative explanations and threat matrix

The purpose of this file is to prevent a preferred narrative from absorbing every observed trend.

| Observed pattern | Preferred mechanism | Important alternative explanations | Empirical response |
|---|---|---|---|
| Tradable occupation declines locally after broadband growth | geographic competition expands | local demand shock, composition change, urban sorting, automation unrelated to broadband | area×year and occupation×year FE, event study, migration analysis, placebos |
| Occupation disappears from small markets | erosion of local niche | population decline, industry closure, survey cell sparsity | minimum-cell rules, population controls in descriptive work, alternative data, matched local occupations |
| Employment concentrates in large metros | superstar/market integration | agglomeration, urban amenities, college sorting | exclude superstar metros, migration decomposition, compare low-tradability occupations |
| Legacy publishing employment falls | digital intermediaries displace local institutions | secular advertising change, consolidation, printing technology, recession | label national trends descriptive; do not use as causal evidence |
| Independent creator employment rises | entry becomes easier | classification shifts, gig-work reclassification, macro labor supply | compare definitions/vintages, use independent datasets |
| Earnings middle weakens | attention/reward concentration | worker composition, hours, selection into self-employment | hours controls, quantile outcomes, cohort/entry analysis |
| AI-exposed work declines after 2022 | AI substitution | macro slowdown, tech-cycle shock, interest rates, sector-specific demand | exposure interactions, comparison groups, platform-specific designs, label observational results appropriately |
| Lower-skill workers gain more from AI | skill compression | ceiling effects, task design, learning effects | rely on experimental estimates and task-specific interpretation |
| Young people enter occupations less often | expected returns fall | education trends, tastes, geography, demographics | cohort models, occupation trends, comparison occupations |

## Directed causal logic

For Wave 1, the principal confounding concern is:

Local economic conditions -> Broadband deployment
Local economic conditions -> Occupation outcomes

The main interaction design attempts to isolate differential changes across occupations within the same local economy, but this is insufficient if local shocks themselves differentially affect occupations according to digital tradability.

Therefore the paper requires:

- dynamic pre-trend evidence
- negative-control occupations
- treatment-definition robustness
- migration analysis
- alternative geography
- where feasible, supply-side rollout variation

## Post-treatment controls

Variables potentially affected by broadband adoption will not be casually inserted as controls in the main specification.

Examples may include:

- local industry composition after treatment
- migration after treatment
- firm entry after treatment
- remote-work prevalence after treatment

These are possible mediators and conditioning on them can change the estimand or introduce bias.

They may be outcomes or mechanism variables in separate analyses.

## Collider warning

Selection into observed employment, platform participation, self-employment, or surviving occupations can create collider bias.

Any analysis conditional on remaining employed or remaining on a platform must state the selected population explicitly.

## Measurement-error warning

Broadband availability is not broadband adoption.

Advertised availability is not realized speed.

Occupation codes change.

Geographic definitions change.

Small occupation-by-area cells are noisy.

Measurement error may attenuate coefficients or create differential bias if data quality correlates with geography.

Every primary variable therefore requires a measurement section, not merely a source citation.
