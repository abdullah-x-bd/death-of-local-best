# Study A data architecture: employer destruction versus independent reallocation

## Updated design

The Craigslist extension should not begin with sparse occupation-by-PUMA cells.

The first worker-market extension will instead exploit annual **county-level administrative business data** that align directly with Craigslist's county treatment geography.

### Dataset 1: County Business Patterns (CBP)

CBP reports annual county-level:

- employer establishments
- employment
- first-quarter payroll
- annual payroll

at detailed NAICS industry levels.

Primary newspaper industry:

**NAICS 511110: Newspaper Publishers**

This is exact enough to measure the employer side of the affected local institution independently of the newspaper-directory staffing data used in the original Craigslist paper.

Candidate outcomes:

- employment
- establishments
- annual payroll
- payroll per employee where disclosure permits

### Dataset 2: Nonemployer Statistics (NES)

NES reports annual county-level:

- number of businesses with no paid employees
- total receipts

from 1997 onward.

Primary independent-work industry:

**NAICS 711510: Independent Artists, Writers, and Performers**

The 2002 NAICS definition explicitly includes independent journalists.

Candidate outcomes:

- nonemployer establishments
- total receipts
- receipts per establishment

## Core new mechanism test

The most interesting extension is not simply whether newspaper payroll employment falls. The original paper already establishes newspaper staffing cuts.

The new question is whether digital destruction of a local intermediary is followed by a shift from employer-based work toward independent production.

The mechanism prediction is:

Craigslist exposure
-> newspaper employer contraction
-> possible increase in local independent/freelance activity

This generates a joint outcome pattern rather than a single coefficient.

## Four possible empirical outcomes

### 1. Employer contraction + independent expansion

Interpretation:
institutional destruction with partial reorganization toward freelance/nonemployer work.

### 2. Employer contraction + no independent expansion

Interpretation:
local paid work is destroyed or displaced elsewhere rather than reorganized locally.

### 3. Employer contraction + independent contraction

Interpretation:
broader local creative/journalistic ecosystem decline.

### 4. No employer contraction in CBP

Interpretation:
either the original newspaper staffing effect is not visible in administrative employer totals, treatment aggregation differs, or measurement/suppression is too severe. The extension must be re-evaluated before proceeding.

## Important limitation of NES 711510

711510 is broader than journalism.

It includes independent artists, writers, performers, producers, and technical specialists.

Therefore a Craigslist effect on 711510 is a diluted proxy for independent journalism and related creative work, not a direct count of freelance journalists.

This makes a positive result notable but makes a null result weak evidence against freelancer reallocation.

We will not reinterpret a null NES result as proof that displaced journalists did not freelance.

## Additional Census QWI module

Quarterly Workforce Indicators can provide:

- employment
- hires
- separations
- earnings
- worker age
- education and other demographics

at county and industry levels.

However, county-level detailed industry support must be audited. Public QWI documentation indicates detailed NAICS predicates, while some extraction interfaces impose finer-industry restrictions by geography.

QWI is therefore secondary until we verify that newspaper publishing can be isolated at an acceptable NAICS level at county geography.

If only 4-digit 5111 is available at county level, the measure combines newspapers with other publishers and will be treated as a diluted robustness outcome.

## ACS role after this update

ACS remains useful for:

- occupation switching
- migration
- self-employment status
- workplace versus residence
- age-specific occupational entry

But the journalism occupation is sparse at PUMA-year level.

Therefore ACS will not be forced into a binary local-presence design without a false-zero/sampling-power analysis.

The administrative county datasets now take priority for Study A's first extension.

## Time window

Target core window:

1998-2010

Reasons:

- overlaps Craigslist expansion
- CBP annual county files are available
- NES annual county files are available
- 2002 NAICS definitions can be harmonized through the central expansion period

Industry-code continuity across the 1997/2002/2007 NAICS vintages must be checked explicitly before pooling.

## Treatment

Use the original Craigslist replication county-year treatment and pre-treatment classified-reliance exposure if reproducibly obtainable.

Do not reconstruct Craigslist dates from scratch unless replication data prove inaccessible.

## Estimation hierarchy

### Stage 1: replicate known employer shock

Using our county treatment construction, verify a decline in newspaper employer outcomes.

### Stage 2: independent-work response

Estimate the same event-time treatment on NES 711510 outcomes.

### Stage 3: joint interpretation

Report employer and nonemployer effects side by side.

Never infer a labor-market reallocation mechanism from either side alone.
