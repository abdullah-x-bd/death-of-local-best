# Decision Log

## 2026-09-29: causal architecture v1

### Decision 1
Do not use a simple 1997-versus-2025 OEWS comparison as causal evidence.

Reason:
occupation codes, survey methods, and metropolitan definitions change over time.

### Decision 2
Do not treat ChatGPT's November 2022 release alone as a clean natural experiment.

Reason:
there is no untreated economy-wide control group and several labor-market trends predate the release.

### Decision 3
Anchor the mechanism with a randomized marketplace experiment.

Reason:
market integration, scalability, and an AI outside option can be randomized independently.

### Decision 4
Use broadband program exposure as the primary real-world first-wave quasi-experiment.

Preferred source:
BIP/BTOP treatment with rejected applicants as controls, upgraded to a near-cutoff or score-based design if application scores can be recovered credibly.

### Decision 5
Use a triple-difference structure with geography × occupation, geography × year, and occupation × year fixed effects.

Reason:
this removes persistent local specialization, contemporaneous local shocks, and national occupation shocks simultaneously.

### Decision 6
Measure heterogeneity by pre-treatment local comparative advantage.

Reason:
market integration theory predicts weak regions and superstar clusters can move in opposite directions.

### Decision 7
Separate tradability from ICT use.

Reason:
an occupation can use computers heavily without its output being digitally tradable, and an occupation can produce highly scalable digital output without unusually intensive computer use.

### Decision 8
Construct occupation characteristics using pre-treatment or early-treatment task data.

Preferred:
DOT 1991 and early O*NET archives.

Reason:
avoid defining treatment using characteristics that may themselves have changed because of digitization.

### Decision 9
Require multiple independent AI exposure measures.

Reason:
model-generated occupation exposure scores are measurement-sensitive.

### Decision 10
Treat Nature-level positioning as contingent on evidence, not on framing.

Minimum evidentiary package for the strongest claim:
- randomized mechanism
- strong field quasi-experiment
- second independent real-world mechanism or replication
- AI-era second shock
- preregistered analysis
- public reproducibility package


## 2026-09-29 — Start of empirical execution

- The private IPUMS USA extract is available as `usa_00001.dat.gz` with DDI, R command file, and basic codebook in the private Hugging Face data vault.
- GitHub Actions authentication to that private repository has been verified successfully.
- Stage 1 is restricted to ingestion, variable/sample validation, and descriptive outcome construction.
- No primary causal coefficient may be estimated in Stage 1.
- The broadband treatment definition, geographic exposure mapping, occupation crosswalk, market-shelter measures, outcome definitions, and exclusion rules must be frozen before the first confirmatory treatment-effect regression.
- Stage 1 may reveal data defects or unavailable variables. Repairs motivated by data availability must be logged here and may not be justified by treatment-effect magnitude or statistical significance.
