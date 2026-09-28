# Construct occupation-level digital tradability.
#
# IMPORTANT:
# This script must be frozen before headline outcome regressions.
# It may not use labor-market outcomes to choose weights, variables,
# occupations, or cutoffs.

source(file.path("R", "00_config.R"))

stop(
  paste(
    "Tradability construction is intentionally not implemented yet.",
    "First select and document the predetermined occupation-characteristic source",
    "and freeze the scoring rule in the analysis plan."
  )
)
