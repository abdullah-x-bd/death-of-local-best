# Data provenance

This file records source, unit, vintage, known limitations, and intended use of every dataset.

## A. BLS Industry Productivity via FRED

### Newspaper Publishers

Series: IPUJN51111W200000000

Source: U.S. Bureau of Labor Statistics, Industry Productivity.

Frequency: annual.

Unit: thousands of jobs.

Coverage currently verified: 1987-2025.

Employment includes wage and salary workers, unincorporated self-employed workers, and unpaid family workers working within business establishments.

Use: descriptive institutional-employment trend only. This national industry series is not a causal treatment dataset.

Primary source page:
https://fred.stlouisfed.org/series/IPUJN51111W200000000

### Newspaper, Periodical, Book, and Directory Publishers

Series: IPUJN5111W200000000

Source: U.S. Bureau of Labor Statistics, Industry Productivity.

Frequency: annual.

Unit: thousands of jobs.

Coverage currently verified: 1987-2025.

Use: broader publishing-sector descriptive trend.

Primary source page:
https://fred.stlouisfed.org/series/IPUJN5111W200000000

### Independent Artists, Writers, and Performers

Series: IPUSN7115W200000000

Source: U.S. Bureau of Labor Statistics, Industry Productivity.

Frequency: annual.

Unit: thousands of jobs.

Coverage currently verified: 1987-2025.

Use: descriptive comparison showing that collapse of legacy intermediaries is not equivalent to disappearance of independent creative activity.

Primary source page:
https://fred.stlouisfed.org/series/IPUSN7115W200000000

## B. ACS 1-year PUMS

Source: U.S. Census Bureau.

Coverage: 2005-2019 and 2021-2024 for standard 1-year PUMS as currently documented.

Potential variables include occupation, employment, wages and income, hours, person weights, age, education, self-employment indicators, migration variables, and geography.

Important 2026 access note: Census currently states that Census Data API queries require an API key. Bulk PUMS files may therefore be preferable for a fully reproducible pipeline that does not depend on a private credential.

Documentation:
https://www.census.gov/programs-surveys/acs/microdata/documentation.html

API overview:
https://www.census.gov/data/developers/data-sets/census-microdata-api/acs-1y-pums.html

Use: principal individual-level labor-market dataset.

## C. OEWS

Source: U.S. Bureau of Labor Statistics Occupational Employment and Wage Statistics.

Use: geographic descriptive validation and selected occupational estimates.

Critical limitation: BLS does not recommend treating published OEWS estimates as a conventional time series without careful attention to occupational classifications, geographic definitions, estimation changes, and pooled samples.

Rule: no core causal claim will be based on naive year-to-year OEWS comparisons.

## D. Historical broadband

Candidate sources:

1. NTIA State Broadband Initiative archived data
2. FCC Form 477 fixed broadband deployment data
3. historical infrastructure or supply-side measures used in published broadband research

Required fields include geography, date, technology, availability, speed threshold where available, and provider count where available.

Use: Wave 1 treatment.

No broadband source becomes primary until its geographic comparability, reporting incentives, and measurement error are documented.

## E. Occupation characteristics

Candidate source: historical O*NET releases or a published occupation-tradability classification.

Use: predetermined digital-tradability moderator.

The index must be constructed without using post-treatment labor-market outcomes.

## F. CPS / IPUMS CPS

Potential use: independent replication and longer temporal coverage.

Important issues include changing occupation codes, changing metropolitan identifiers, sample size for small occupation × geography cells, and earnings consistency.

CPS will be treated as a replication dataset rather than silently pooled with ACS.

## G. AI exposure data

Candidate sources include published occupational exposure measures.

Selection criteria:

- transparent task-to-occupation mapping
- reproducible construction
- coverage of occupational universe
- measurement date clearly separated from labor outcomes where possible

Use: Wave 2 moderator.

No exposure index will be selected on the basis of which produces the strongest coefficient.
