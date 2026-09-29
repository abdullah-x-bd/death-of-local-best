# Power simulation scaffold for the confirmatory marketplace experiment
#
# This file intentionally does not encode treatment-effect assumptions yet.
# Pilot data will be used only to estimate nuisance parameters such as:
# - market-level ICC
# - within-market outcome variance
# - buyer participation variance
# - attrition
#
# The smallest scientifically meaningful treatment effect must be chosen
# before confirmatory outcome data are collected.

set.seed(20260929)

simulate_trial <- function(
  markets_per_cell,
  producers_per_market = 10,
  rounds = 8,
  icc = 0.05,
  residual_sd = 1,
  effect_integration_scalable = -0.15
) {
  # Placeholder scaffold.
  # Replace with a design-based simulation after Stage 0 pilot estimates
  # nuisance parameters. Confirmatory assumptions and seed will then be frozen.
  stop("Pilot nuisance parameters not yet frozen.")
}

# Required design criterion:
# >= 95% power for the smallest primary interaction considered scientifically
# meaningful after family-wise error correction.
