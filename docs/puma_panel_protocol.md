# PUMA outcome panel protocol

The BIP/BTOP treatment is geographically concentrated and disproportionately relevant to rural and underserved places. A metro-only IPUMS design would discard many treated areas.

Therefore the primary microdata geography for the broadband field design is PUMA, not MET2013.

## PUMA vintages

The raw panel tags each cell explicitly:

- 1990 observations use 1990 PUMAs.
- 2000 through 2011 observations use 2000 PUMAs.
- 2012 through 2021 observations use 2010 PUMAs.
- 2022 onward observations use 2020 PUMAs.

PUMA codes are state-dependent and are always paired with STATEFIP.

## Internet-wave primary window

The primary broadband field analysis will harmonize the 2000-PUMA observations into a 2010-PUMA target geography using official Census geographic relationships and population weights, then use a window that ends before the 2022 switch to 2020 PUMAs.

This avoids silently treating changing PUMA definitions as stable local markets.

## Outcomes produced before treatment merge

For each year × PUMA vintage × state × PUMA × OCC2010 cell:

- weighted employment
- young-worker employment share
- self-employment share
- nominal wage numerator and denominator
- usual-hours numerator and denominator
- unweighted worker count

PUMA-year working-age and employment denominators are stored separately.

No broadband treatment variable is read while building this panel.
