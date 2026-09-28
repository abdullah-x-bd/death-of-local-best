# Broadband treatment source audit

## Objective

Identify a broadband measure whose timing, geography, and measurement properties align with the claimed first digital wave.

## 1. NTIA State Broadband Initiative

Verified public releases exist every six months from June 2010 through June 2014.

The June 2010 national availability database contains roughly 25 million records.

Strengths:

- high geographic granularity
- technology and speed information
- repeated semiannual vintages
- public documentation
- useful for later-stage broadband diffusion and validation

Weakness:

- begins too late to stand in for the entire initial internet/broadband diffusion wave

Decision:

Do not describe 2010-2014 alone as the original internet shock.

Potential use:

- treatment for a later broadband-upgrading analysis
- validation of earlier availability measures
- robustness around local market integration after basic broadband diffusion

Source:
https://www2.ntia.gov/broadband-data

## 2. FCC Form 477 before 2008

FCC Form 477 data collection began with connections as of December 31, 1999.

From December 1999 through June 2008, providers reported state-level connection counts and identified ZIP Codes in which they had at least one high-speed connection in service.

From June 2005, technology-specific ZIP Code lists were required.

Strengths:

- timing aligns far better with early broadband diffusion
- semiannual collection
- used in prior peer-reviewed broadband research

Weaknesses:

- a reported connection somewhere in a ZIP Code is not full-coverage availability
- customer counts were not reported by ZIP Code
- early measurement is much less granular than later FCC/NTIA systems
- near-universal ZIP presence by the late 2000s makes binary presence increasingly uninformative
- historical raw-data accessibility and consistent archival construction still need to be verified

Implication:

The early Form 477 measure is a plausible candidate for the first-wave treatment, but it must be interpreted as a noisy market-presence measure rather than exact household availability.

## 3. FCC change in 2008

The FCC materially changed Form 477 for data as of December 31, 2008.

Fixed-location broadband connections began to be reported at census-tract level, with much more detailed speed information.

Implication:

A long panel that crosses 2008 contains a structural measurement break.

Any design spanning the break must either harmonize to a common coarser concept or explicitly model separate regimes.

## 4. Kolko (2012)

Kolko studies U.S. broadband expansion between 1999 and 2006 using FCC Form 477 data and local employment data.

The paper uses uneven broadband diffusion and an instrument based on terrain slope as one causal strategy.

Important methodological lesson:

The paper itself characterizes the IV evidence as leaning toward causality rather than definitive.

Use for this project:

- precedent that 1999-2006 FCC variation can support local economic analysis
- source for historical measurement choices
- model for an explicit discussion of instrument limitations

Do not import the terrain instrument automatically.

Terrain can affect transportation, urban form, density, tourism, industry, and migration. An exclusion-restriction audit is required for our outcomes.

## 5. Atasoy (2013)

Atasoy studies broadband expansion from 1999 to 2007 and local labor-market outcomes.

Use:

- additional precedent for early diffusion period
- literature comparator for aggregate employment effects

Our contribution differs because the central interaction is occupation-level digital tradability and the primary outcomes include local occupational presence and distributional structure.

## 6. Current preferred treatment strategy

Provisional hierarchy:

1. Reconstruct an early 1999-2007 ZIP or county broadband diffusion measure from FCC Form 477 archives or a documented research replication source.
2. Harmonize to a geographic unit that can be linked credibly to labor microdata.
3. Treat the 2008 reporting redesign as a measurement break.
4. Use NTIA 2010-2014 data as validation and/or a distinct later-diffusion exercise.
5. Keep broadband adoption conceptually separate from broadband availability.

## 7. Unresolved questions

- Can the complete historical ZIP lists be obtained directly from FCC archives for every semiannual vintage?
- Which geographic unit produces the best tradeoff between measurement quality and labor sample size?
- Should treatment be first broadband presence, provider-count growth, technology-specific presence, or a continuous diffusion measure?
- Can DSL technical-distance measures or other supply constraints provide a stronger source of quasi-experimental variation?
- How stable are ZIP-to-county and ZIP-to-PUMA crosswalks over the period?
- Can the first-wave design begin before ACS in a CPS or Census-based replication?
- What exact treatment date definition minimizes anticipation and measurement error?

No primary treatment variable will be selected until these questions are resolved.
