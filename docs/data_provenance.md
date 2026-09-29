# Data Provenance and Acquisition Plan

## Principle

Raw restricted or licensed data are never committed to the public repository.

The repository stores:
- acquisition scripts where legally permitted
- checksums
- source URLs
- version numbers
- dictionaries
- crosswalk code
- synthetic test fixtures

## Tier 1: public data that can be acquired immediately

### BLS OEWS

Purpose:
occupation × metropolitan area employment and wages.

Coverage:
annual data from 1997 onward, with documented classification and metropolitan-definition changes.

Source:
https://www.bls.gov/oes/

Use:
descriptive occupational geography, concentration, local share, wage outcomes.

Critical limitation:
OEWS is not a mechanically consistent time series. Occupation and geography harmonization is mandatory.

### O*NET historical archives

Purpose:
construct occupation characteristics using information measured before or early in the digital transition.

Preferred versions:
- O*NET 4.0, June 2002
- O*NET 5.0, April 2003

Source:
https://www.onetcenter.org/db_releases.html

Use:
physical presence, face-to-face interaction, information processing, work context, task characteristics.

### Dictionary of Occupational Titles 1991

Purpose:
pre-internet occupation characteristics and robustness against using post-treatment task descriptions.

Source:
U.S. Department of Labor public-domain materials and ICPSR release.

Use:
historical task/occupation characteristics.

### NTIA BTOP/BIP archives

Purpose:
broadband grant applications, awards, proposed service areas, performance records.

Sources:
https://www2.ntia.gov/
https://catalog.data.gov/

Use:
construct treatment, rejected-applicant comparison pool, treatment timing, geography.

### National Broadband Map / SBI

Purpose:
broadband availability validation beginning in 2010.

Source:
NTIA archived National Broadband Map datasets.

Use:
first-stage validation that funded treatment actually increased broadband availability.

### Census County Business Patterns and Nonemployer Statistics

Purpose:
local establishment counts and self-employment proxies by industry.

Use:
institutional and entrepreneurship outcomes.

## Tier 2: free but user-authenticated data

### IPUMS USA

This is the most important user-provided dataset.

Access is free to registered users but extract creation requires an IPUMS account.

Requested samples:
- 1990 Census 5 percent if available under the user's access
- 2000 Census
- ACS annual samples, ideally 2005 through latest available year

Requested variables:
- YEAR
- SAMPLE
- SERIAL / PERNUM or equivalent non-identifying record keys
- PERWT
- AGE
- SEX
- EDUC / EDUCD
- EMPSTAT / EMPSTATD
- OCC
- OCC1990 or another harmonized occupation variable
- IND / IND1990 where appropriate
- CLASSWKR
- INCWAGE
- INCTOT
- UHRSWORK
- WKSWORK2 or available weeks-work variable
- METAREA / MET2013 or consistent metro variables where available
- STATEFIP
- PUMA
- MIGRATE1 / MIGPLAC1 where available
- TRANWORK / WORKEDYR / WORKSTAT variables if available

Exact extraction list will be finalized against IPUMS availability.

Purpose:
validate OEWS results with individual microdata and measure earnings, occupational entry, self-employment, migration, age gradients, and worker characteristics.

## Tier 3: high-value proprietary or collaboration data

### Lightcast

Priority: very high.

Needed fields:
- posting date
- occupation
- geography
- seniority/experience
- salary where present
- employer
- job title
- skills
- remote status

Purpose:
high-frequency post-2022 AI labor-demand analysis.

### Revelio Labs

Alternative/complement to Lightcast.

Purpose:
worker and vacancy transitions, firm-level hiring and occupational composition.

### Upwork platform data or research collaboration

Priority: exceptionally high for the AI second-shock claim.

Ideal fields:
- job posting timestamp/category
- bids
- contract award
- price
- freelancer history
- skill category
- geography
- AI-tool access/adoption where available

A randomized Upwork/Microsoft field experiment already exists in the literature. Direct collaboration or transaction data would materially strengthen this project.

### ADP payroll microdata

Extremely valuable but difficult to access.

Purpose:
worker-level employment changes by age/experience and occupation after AI diffusion.

## Optional external datasets

- UNC/Medill Local News Initiative newspaper closure data
- newspaper circulation and classified-ad dependence data
- historical Craigslist city-entry dates
- QCEW
- LEHD/LODES
- Census Business Dynamics
- CPS Computer and Internet Use supplements
- FCC Form 477 / Broadband Data Collection
- historical internet backbone/fiber route data
- historical cable-TV infrastructure
- terrain and topography for instrumental-variable robustness

## Data the user can help obtain

Highest priority, in order:

1. IPUMS USA extract.
2. Lightcast or Revelio access if available through an institution.
3. Any Upwork/Fiverr transaction dataset or research-access route.
4. ICPSR DOT 1991 files if institutional membership gives downloadable machine-readable files.
5. Newspaper-level circulation/employment/licensed datasets if institutional library access exists.

## Provenance requirements

Every external file receives:
- source
- date accessed
- original filename
- SHA-256 checksum
- license/access condition
- transformation script
- derived-file checksum

No manual spreadsheet edits to analytical data.
