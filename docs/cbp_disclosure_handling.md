# County Business Patterns disclosure handling

## Historical publication rule

For the historical CBP county files relevant to Study A, employment and payroll can be withheld for confidentiality or publication-quality reasons.

The record layout gives an EMPFLAG containing the employment-size class when exact employment is withheld.

Exact establishment counts remain published in the historical layout even when employment/payroll are suppressed.

## Primary outcome hierarchy

### Primary exact outcome

Number of newspaper-publisher establishments, NAICS 511110.

Reason:

- exact rather than imputed
- county-level
- annual
- directly measures whether employer organizations survive/enter/exit locally

Limitation:

It is an institutional-count outcome, not a worker-count outcome.

### Secondary partially identified outcome

Mid-March employment in NAICS 511110.

Use EMPFLAG to bound censored values rather than midpoint-impute them.

### Additional secondary outcome

Annual payroll, where publishable.

Payroll censoring will not be silently converted to zero.

## Why establishment counts cannot replace staffing evidence

A newspaper can cut half its newsroom while remaining one establishment.

Therefore the employer-establishment result and the published Djourelova-Durante-Martin staff result answer different questions.

Our causal chain uses both:

Craigslist shock
-> published newsroom staffing decline
-> our administrative evidence on employer-establishment survival and/or employment
-> our nonemployer evidence on independent-work reallocation

## Potential partial-identification contribution

For a fixed linear specification, every OLS treatment coefficient is a linear functional of the outcome vector.

If censored employment values are known only to lie inside EMPFLAG intervals, we can calculate coordinatewise sharp bounds on the coefficient without midpoint imputation.

This analysis will be treated as a robustness/secondary contribution until inference for the partially identified parameter is fully specified.
