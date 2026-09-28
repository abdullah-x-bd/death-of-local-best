# Outcome-data architecture audit

## Objective

Choose labor-market data that match the early broadband diffusion window while preserving occupation detail, local geography, earnings, self-employment, migration, and entry outcomes.

## 1. Preferred microdata architecture: Census 2000 5% PUMS plus ACS PUMS

### Why this is attractive

The Census 2000 5% PUMS is a very large individual-level sample and identifies Public Use Microdata Areas (PUMAs) with a minimum population of roughly 100,000.

ACS PUMS through 2011 uses the 2000-based PUMA geography. The ACS switches to 2010-based PUMAs beginning with 2012 data.

This gives us an unusually convenient common geography during the first broadband diffusion period.

The early-2000s occupation classifications are also unusually compatible. CPS/BLS documentation indicates that the 2002 Census occupation classification is derived from the 2000 SOC, and the 2000 and 2002 Census occupation codes are essentially the same underlying scheme with formatting differences for most purposes.

### Candidate panel

Baseline:
- Census 2000 5% PUMS

Follow-up:
- ACS 2005
- ACS 2006
- ACS 2007
- potentially ACS 2008-2011 for later dynamics, subject to the broadband measurement design

### Advantages

- very large samples relative to CPS
- individual earnings and demographic information
- self-employment
- migration variables
- age and education
- stable 2000 PUMA geography through 2011
- sufficiently large local units for many occupation cells
- public bulk downloads

### Limitations

- PUMA is residence geography, not workplace geography
- minimum population around 100,000 means this cannot observe genuinely small towns
- no annual ACS microdata before 2005 at full national scale
- ZIP-code broadband must be crosswalked to PUMA rather than joined directly
- occupation-by-PUMA cells can still be sparse for rare occupations
- PUMA boundaries do not necessarily align with local labor markets

### Role

Current preferred source for the main occupation-level first-wave analysis, subject to a successful ZIP-to-PUMA broadband crosswalk and cell-reliability audit.

## 2. CPS

BLS documentation gives a particularly useful occupation window:

- January 2000 to December 2010 use the 2002 Census occupation classification derived from the 2000 SOC, after BLS retrospectively revised 2000-2002 data.

IPUMS CPS also supplies metropolitan identifiers and harmonized occupation measures.

### Advantages

- monthly data
- early broadband period fully covered
- occupation classifications unusually stable from 2000-2010
- can support dynamic pre/post analysis

### Limitations

- much smaller sample than Census/ACS for occupation-by-metro cells
- individuals appear repeatedly in monthly CPS panels unless sampling is handled carefully
- metro definitions change in May 2004 and some metros are unidentified
- earnings measures vary by CPS rotation/supplement
- IPUMS custom extracts may add a credential-dependent reproducibility step

### Role

Potential dynamic replication and falsification dataset rather than the sole primary source.

A specific sampling design must be frozen before use. We should not pool all monthly observations as if they were independent people.

## 3. OEWS

Advantages:

- establishment-based occupational employment
- detailed occupations
- detailed metropolitan geography

Severe limitation:

BLS explicitly discourages conventional time-series use because of changes in occupational, industrial, geographic, and estimation systems and the permanent three-year pooled-sample design.

The 2002 estimates also mix survey panels from 1999-2002.

Role:

descriptive validation only unless a carefully harmonized restricted period can be defended.

## 4. Decennial Census 1990/2000

Advantages:

- enormous sample
- useful for pre-internet descriptive geography
- directly comparable to the earlier Conference Board analysis

Limitations:

- cannot identify broadband treatment dynamically
- large occupation-classification break from 1990 to 2000
- only two distant points

Role:

prehistory and descriptive validation, not primary causal design.

## 5. Current preferred structure

### Main microdata design

Census 2000 5% PUMS + ACS 2005-2011 on 2000 PUMAs.

### Dynamic replication

CPS 2000-2010 with a prespecified repeated-person and geography strategy.

### Establishment validation

OEWS only where comparability can be shown rather than assumed.

## 6. Critical measurement question

The labor data now appear more tractable than the broadband data.

The remaining bottleneck is not whether local occupation outcomes can be measured. It is whether early Form 477 ZIP measures can be mapped to PUMAs without introducing unacceptable treatment error and whether the 2005 reporting-rule break can be handled transparently.

## Sources

U.S. Census Bureau, Census 2000 PUMS documentation.

U.S. Census Bureau, ACS PUMS geography documentation.

U.S. Bureau of Labor Statistics, Historical comparability of CPS occupation and industry data.

U.S. Bureau of Labor Statistics, OEWS historical methodology and FAQ.
