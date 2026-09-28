# Geography crosswalk design for Study A

## Source

Census 2000 5% PUMS Geographic Equivalency files.

These files explicitly describe relationships between 2000-based PUMAs and standard Census geographies.

Summary level 780 gives the total population of each PUMA.

Summary level 781 gives the population of each county, or county part, contained within that PUMA.

Therefore we can construct a population-based county-to-PUMA treatment crosswalk from an official Census source rather than a third-party approximation.

## Treatment aggregation

If Craigslist treatment is observed at county c in year t, define the population-weighted PUMA treatment as:

CL_pt = sum_c w_cp * CL_ct

where:

w_cp = Population(c part in p) / Population(p)

and the weights are fixed using Census 2000 population.

Using fixed baseline population avoids creating a post-treatment weight.

## Classified-reliance exposure

If baseline classified-ad exposure can be defined at county level from newspapers in the replication data, construct analogously:

Exposure_p0 = sum_c w_cp * Exposure_c0

The exact county exposure definition remains to be frozen.

## Main ambiguity rule

PUMAs can contain multiple counties and counties can be split across multiple PUMAs.

This is not hidden.

We will report:

- treatment share CL_pt between 0 and 1
- number of counties represented in each PUMA
- Herfindahl or dominant-county share of PUMA population
- fraction of PUMAs whose counties disagree in Craigslist treatment status in a given year

## Primary-versus-sensitivity geography

Candidate primary:

Continuous population-weighted treatment CL_pt.

Candidate high-purity sensitivity:

Restrict to PUMA-years in which at least 90% of the PUMA population has the same Craigslist treatment status.

Candidate exact-county sensitivity:

Restrict to PUMAs wholly contained in one county, or counties wholly represented by a PUMA, depending on support.

The threshold will be frozen before worker outcomes are inspected.

## Why not assign the dominant county to the whole PUMA?

Doing so converts partial treatment into deterministic treatment and can introduce non-classical misclassification.

Population-weighted exposure keeps the aggregation transparent.

## Workplace PUMA complication

ACS place-of-work PUMA is a disclosure geography and may aggregate standard PUMAs.

We must not assume POWPUMA equals residence PUMA.

Before making workplace outcomes primary:

1. acquire the Census POWPUMA definition/conversion information
2. determine how 2000 standard PUMAs aggregate into each POWPUMA
3. aggregate county treatment consistently to the workplace geography

If that mapping is not reproducible, residence-PUMA outcomes remain primary and workplace outcomes become a restricted validation exercise.

## Sampling zeros

A PUMA can contain no sampled reporter even when reporters exist in the population.

Therefore "occupation absent" cannot be defined as raw zero sample count without quantifying false-zero probability.

For rare journalism occupations, primary Study A outcomes will likely be weighted employment counts/shares and individual-level outcomes.

The geographic-presence outcome is retained for Study B or for aggregated occupation families where sampling reliability is demonstrably adequate.
