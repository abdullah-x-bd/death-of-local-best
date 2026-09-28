# Early FCC Form 477 measurement audit

## 1. What the early data actually measure

For December 1999 through June 2008, broadband providers reported:

- state-level counts of high-speed connections
- ZIP Codes in which they had at least one high-speed connection in service

The ZIP lists therefore measure subscriber/provider presence somewhere in a ZIP, not universal household availability.

FCC reports explicitly warn that one subscriber in a ZIP does not reveal the extent of availability or whether service was residential or business-focused.

## 2. Reporting threshold break

From 1999 through 2004, providers generally had to file only if they had at least 250 high-speed lines in a state.

Beginning with the June 2005 collection, this threshold was removed and all relevant providers were required to report.

This creates a mechanical upward break in measured provider presence/counts that is unrelated to actual new deployment.

## 3. Technology-specific reporting

For data as of June 30, 2005 and later, providers supplied technology-specific ZIP lists.

This is another measurement-regime change.

## 4. Saturation

Early broadband presence diffused rapidly.

Prior research reconstructing ZIP availability reports that more than half of ZIPs already appear in the December 1999 collection. By the late 2000s, simple any-provider presence is close to saturated.

Therefore "first broadband arrival" is a noisy and increasingly weak treatment.

## 5. Geography

ZIP Codes are postal geographies rather than stable Census geographic units.

Crosswalking ZIP measures to PUMAs, counties, or tracts can introduce error because ZIPs are not cleanly nested within Census geography.

Any ZIP-to-PUMA treatment must be population-weighted using a documented crosswalk and subjected to alternative-crosswalk sensitivity.

## 6. Consequence for our causal design

The project will not treat 1999-2007 provider counts as one homogeneous continuous series.

Candidate strategies:

### Strategy A: 1999-2004 regime only

Use the original reporting threshold consistently and focus on early diffusion.

Pros:
- coherent reporting regime
- closest to first-wave timing

Cons:
- small providers missing, especially in rural places
- ACS does not yet provide a national annual microdata panel before 2005
- treatment already starts after some places had broadband

### Strategy B: 2005-2007 regime only

Use the post-threshold, technology-specific regime.

Pros:
- broader provider coverage
- overlaps national ACS PUMS

Cons:
- short window
- basic presence is already highly saturated
- this is later diffusion rather than initial arrival

### Strategy C: regime-specific standardized treatment

Estimate effects separately within each regime and avoid comparing raw provider counts across the 2005 break.

Only combine estimates at the interpretation/meta level if signs and magnitudes are coherent.

### Strategy D: externally reconstructed historical broadband measure

Use a published research replication dataset that has already reconstructed the ZIP panel, provided its construction is fully auditable.

This is preferable to hand-extracting password-protected historical FCC files if a trustworthy replication source can be obtained.

## 7. Additional quasi-experimental candidates

The search should continue for supply-side or policy variation that is better than raw Form 477 rollout.

Candidates:

- DSL technical-distance constraints
- historical telephone-network topology
- rural broadband program eligibility
- cable-system footprints
- local Craigslist entry for the platform/intermediary module

No instrument or policy treatment will be adopted without a specific exclusion-restriction audit.

## 8. Key implication

The early FCC data can support a serious paper, but only if the measurement regime itself becomes part of the design. Treating the raw series as clean "broadband availability" would create exactly the methodological weakness this project is intended to avoid.
