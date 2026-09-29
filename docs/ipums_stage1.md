# IPUMS USA Stage 1 empirical ingestion

This stage is the first run on the actual IPUMS USA extract stored in the private Hugging Face data vault.

It is intentionally pre-confirmatory. It does not estimate the paper's primary causal coefficient before treatment definitions, crosswalks, exclusions, and outcome rules are frozen.

## What it does

1. Reads the IPUMS DDI and records the exact variable inventory.
2. Verifies requested-variable coverage.
3. Streams the compressed fixed-width microdata in 500,000-row chunks.
4. Produces weighted year/sample labor-market diagnostics.
5. Produces weighted state/year diagnostics.
6. Produces occupation/year summaries under OCC1990 and OCC2010 when available.
7. Records young-worker and self-employment shares as preliminary opportunity measures.
8. Records nominal wage and usual-hours means for QA, explicitly not as final real-income outcomes.

## Raw-data rule

The raw `.dat.gz`, DDI, command file, and codebook remain in the private Hugging Face repository. GitHub Actions downloads them only into an ephemeral runner. Raw IPUMS data are never uploaded as a GitHub artifact or committed to the public repository.

## Stage 1 outputs

- `variable_inventory.csv`
- `requested_variable_coverage.csv`
- `sample_year_summary.csv`
- `state_year_summary.csv`
- `occupation_year_occ1990.csv`
- `occupation_year_occ2010.csv`
- `qa_report.json`

These outputs are for data validation and descriptive architecture. The next stage builds occupation × local-market panels and merges frozen pre-treatment market-shelter measures.
