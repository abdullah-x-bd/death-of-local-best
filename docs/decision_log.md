# Research decision log

This file records consequential design choices chronologically.

## 2026-09-28

### D001: Separate descriptive, causal, mechanism, and hypothesis claims

Decision: Every substantive result will be classified internally into one of four evidentiary categories.

Reason: The central topic is unusually vulnerable to overclaiming because descriptive technological trends are highly confounded.

Made before headline regressions: yes.

### D002: Do not use naive broadband-on-employment regression as the main design

Decision: A regression comparing places by broadband levels without occupation-level differential exposure will not be treated as causal evidence.

Reason: Broadband deployment is endogenous to local income, density, education, industry, migration, and technology demand.

Made before headline regressions: yes.

### D003: Primary Wave 1 design uses geography × occupation × year variation

Decision: Main design will exploit interaction between local broadband expansion and predetermined occupation-level digital tradability with high-dimensional fixed effects.

Reason: This better matches the mechanism and absorbs broad local and occupation-level shocks.

Made before headline regressions: yes.

### D004: Digital tradability must be predetermined

Decision: No manual treated-occupation list will be constructed after inspecting outcomes.

Reason: Avoid researcher degrees of freedom and outcome-informed treatment construction.

Made before headline regressions: yes.

### D005: AI section will not equate post-2022 associations with causal effects

Decision: Original AI labor-market analysis is exploratory unless a defensible quasi-experiment is established.

Reason: ChatGPT adoption and occupational exposure are not randomly assigned.

Made before headline regressions: yes.

### D006: OEWS will not be used as a naive time series

Decision: OEWS is reserved for carefully harmonized descriptive work and robustness.

Reason: BLS warns of comparability problems across classifications, geographies, methods, and pooled estimation periods.

Made before headline regressions: yes.

### D007: Preserve disagreement across datasets

Decision: ACS, CPS, OEWS, industry series, and platform evidence will not be forced into one pooled result.

Reason: Differences can reveal measurement, population, or institutional mechanisms.

Made before headline regressions: yes.

### D008: Paper title

Decision: From Local Scarcity to Machine Abundance: Digital Markets and the Erosion of Competence Rents.

Made before headline regressions: yes.

### D009: Separate labor tradability from output scalability

Decision: The first digital wave will not be represented by a single offshorability measure.

Reason: Blinder-style offshorability captures whether labor can be supplied at distance, but it does not capture the separate superstar mechanism in which a locally produced or embodied performance is recorded or distributed at near-zero marginal cost. In the Blinder transcription, writers, editors, translators, and graphic designers score as highly offshorable, while photographers and music directors/composers sit at the non-offshorable boundary. Treating these as one latent construct would mismeasure the original theory.

Empirical consequence:

- Module A studies remote tradability of labor/services.
- Module B studies scalable/reproducible output and attention-market concentration.
- The two mechanisms may be combined theoretically but will not be forced into one empirical exposure index.

Made before headline regressions: yes.

### D010: Prioritize county administrative data for Study A before sparse ACS occupation cells

Decision: The first original extension of the Craigslist newspaper shock will use County Business Patterns and Nonemployer Statistics at county-by-industry-year level. ACS remains a secondary worker-level mechanism dataset.

Reason: reporters/editors are rare enough that annual occupation-by-PUMA presence measures risk substantial false-zero sampling error. CBP and NES align directly with county treatment geography and provide annual employer/nonemployer outcomes.

Made before headline extension regressions: yes.

### D011: Do not identify the Craigslist extension from raw county before/after variation alone

Decision: Where the data permit, the original administrative-data extension will use county-by-year and industry-by-year variation so that the Craigslist coefficient is identified from the differential response of the prespecified affected industry within the same local economy.

Reason: Craigslist entry timing is correlated with market size and internet conditions. A simple treated-county DiD does not absorb time-varying local shocks. County-by-year fixed effects remove all local shocks common across industries in a county-year.

Remaining assumption: local shocks that specifically affect the treated industry at the same time as Craigslist entry can still confound the estimate. Pre-trends, placebo industries, and the published classified-reliance mechanism remain necessary.

Made before headline extension regressions: yes.

### D012: Treat suppressed CBP employment as interval-censored

Decision: Suppressed historical CBP employment values will not be set to zero, dropped without qualification, or midpoint-imputed as the primary method.

Reason: Census provides EMPFLAG size intervals for suppressed cells. Establishment counts are exact, while employment can be analyzed using interval information and partial-identification sensitivity.

Made before headline extension regressions: yes.

### D013: Require mechanism-specific broadband heterogeneity for Study B

Decision: A statistically significant average broadband effect is not sufficient evidence for erosion of geographic scarcity rents.

Reason: the strongest prior natural-experiment evidence on internet competition distinguishes sectors according to whether broadband actually exposes them to outside competition. Our theory likewise predicts heterogeneous effects by predetermined remote tradability.

Requirement:
Study B must identify a broadband/connectivity shock and show that effects vary in the direction predicted by a predetermined tradability measure, with low-tradability occupations serving as negative controls.

Made before headline Study B regressions: yes.
