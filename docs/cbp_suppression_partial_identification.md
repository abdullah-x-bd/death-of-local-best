# Suppression and partial-identification plan for County Business Patterns

## Problem

Historical County Business Patterns publishes the exact number of establishments, but some county-industry employment and payroll cells are withheld for confidentiality or data-quality reasons.

In the 1998-2006 county layout, a suppressed employment cell is replaced by zero and EMPFLAG gives an employment-size interval:

- A: 0-19
- B: 20-99
- C: 100-249
- E: 250-499
- F: 500-999
- G: 1,000-2,499
- H: 2,500-4,999
- I: 5,000-9,999
- J: 10,000-24,999
- K: 25,000-49,999
- L: 50,000-99,999
- M: 100,000 or more

From 2007-2013 the layout also contains noise/publication flags, while EMPFLAG continues to describe intervals for withheld employment.

## What we will not do

We will not:

- treat the published zero as actual zero employment
- drop suppressed cells and call the remaining sample representative
- choose an arbitrary midpoint and present it as observed employment
- select an imputation method according to which yields significance

## Primary exact outcome

The number of employer establishments is published even when historical employment/payroll is withheld.

Therefore establishment counts are a high-integrity exact CBP outcome.

They measure survival/entry of newspaper-employer organizations, not the number of newspaper workers.

## Employment as a partially observed outcome

For each county-industry-year observation, define:

L_i <= Employment_i <= U_i

where exact disclosed observations have L_i = U_i = observed employment and suppressed observations take bounds from EMPFLAG.

The top-coded M category requires a finite sensitivity cap for coefficient bounding. It is unlikely to matter for county-level 6-digit newspaper cells, but the handling rule must be frozen before estimation.

## Sharp coefficient bounds for a linear specification

For a fixed linear regression design matrix X and weights W,

beta_hat = (X' W X)^(-1) X' W y.

Every coefficient is therefore a linear function of y:

beta_j = a_j' y.

If each censored outcome y_i lies independently in [L_i,U_i], the sharp coordinatewise lower and upper OLS bounds for coefficient j are obtained by choosing:

- L_i when a_ji >= 0 for the lower bound
- U_i when a_ji < 0 for the lower bound
- the opposite endpoints for the upper bound

This lets us answer:

> Can the sign of the estimated treatment effect be reversed by any assignment of suppressed employment values that is consistent with Census publication intervals?

If not, the sign is identified despite suppression.

## Fixed effects

The same logic applies after including fixed effects because the OLS coefficient remains a linear function of the outcome for a fixed design.

Implementation must avoid materializing an enormous dense dummy matrix. We can either:

1. use sparse design matrices for the county panel, or
2. derive coefficient influence weights after fixed-effect residualization.

The implementation will be unit-tested on small simulated panels where brute-force enumeration is possible.

## Event-study coefficients

Each event-time coefficient is separately a linear function of y, so coordinatewise identified intervals can be calculated.

These are coefficient-identification bounds, not simultaneous statistical confidence bands.

Sampling uncertainty and partial identification must be reported separately.

## Inference

We will distinguish:

1. **suppression uncertainty**: the identified coefficient interval induced by Census confidentiality intervals
2. **sampling/model uncertainty**: conventional or cluster-robust statistical uncertainty conditional on observed/assigned outcomes

A formal confidence region for a partially identified parameter may be added if employment becomes a headline outcome.

Until then:

- exact establishment outcomes can carry the primary CBP regression
- bounded employment is a stringent sensitivity/secondary analysis
- the original newspaper microdata paper supplies independent evidence on staffing effects

## Why this is preferable to midpoint imputation

Midpoint imputation assumes that every censored cell lies at the center of a very wide interval.

Partial identification makes no such assumption.

If the treatment coefficient remains negative across the entire feasible set, suppression cannot explain the qualitative result.
