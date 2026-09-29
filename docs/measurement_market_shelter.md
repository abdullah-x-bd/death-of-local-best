# Measuring Market Shelter Without Looking at Outcomes

## Objective

Construct occupation-level measures that predate the outcomes and are not chosen to maximize explanatory power.

The framework separates five dimensions.

1. Digital transmissibility
   Can the economically valuable output be delivered remotely?

2. Scalability
   Can substantially more customers be served without proportional additional producer time?

3. Physical-presence dependence
   Must producer and consumer share a location?

4. Capacity constraint
   Does each additional customer require roughly proportional producer time?

5. Relational/accountability dependence
   Does value depend materially on trust, fiduciary responsibility, local knowledge, or an identifiable human relationship?

## Preferred historical source

Primary:
Dictionary of Occupational Titles, 1991.

Secondary:
O*NET 4.0 / 5.0 historical archives from 2002-2003.

Reason:
occupation characteristics should be measured before or near the start of the outcome period, not after occupations have adapted to the internet.

## Human coding study

Occupation descriptions are presented to independent raters with:
- occupation title masked in a robustness arm
- no wage information
- no geography information
- no post-1991 employment information
- no explanation of the hypothesized treatment effect

Raters answer prespecified questions for each dimension.

Example:
"Could the core output of this work be delivered to a distant customer through an electronic network without the worker traveling?"

Five-point response scale with anchored examples.

## Reliability

For each dimension:
- report inter-rater reliability
- pre-specify minimum acceptable reliability
- if reliability fails, the corresponding index is not used as primary treatment intensity

## Index construction

Primary approach:
dimensions remain separate.

This prevents a researcher-chosen composite from hiding which mechanism matters.

Secondary composite:
MarketShelter_o =
  + PhysicalPresence
  + CapacityConstraint
  + RelationalDependence
  - DigitalTransmissibility
  - Scalability

All components standardized using pre-treatment occupation weights.

Weights are equal in the primary composite.

PCA/factor-analysis versions are robustness checks only.

## External validation

Validation targets must not use the main post-treatment outcomes.

Candidate validation:
- Dingel-Neiman work-from-home feasibility
- established offshorability classifications
- occupational telework rates
- historical pre-internet geographic concentration

## AI substitutability

AI exposure is conceptually separate from digital tradability.

An occupation can be digitally tradable but hard for AI.
An occupation can be AI-exposed but embedded in physical local delivery.

Primary AI analysis should therefore interact:

AIExposure_o × DigitalTransmissibility_o

rather than treat them as interchangeable.

## Measurement falsification

If the historical market-shelter measures fail to predict obvious benchmark contrasts such as barber versus copywriter, the coding instrument is revised before outcome analysis.

No outcome-based reweighting is permitted in the confirmatory study.
