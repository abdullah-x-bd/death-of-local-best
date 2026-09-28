# Main Wave 1 model template.
# This file is intentionally non-executable until the panel and treatment
# definitions are frozen.

# Planned specification:
#
# Y_aot = beta * broadband_at * tradability_o
#       + FE(area x occupation)
#       + FE(area x year)
#       + FE(occupation x year)
#       + error_aot
#
# Preferred implementation will use fixest after the analytic panel,
# weighting estimand, and clustering rule are frozen.
#
# No coefficient should be interpreted causally merely because the
# fixed-effects model can be estimated.

stop("Main Wave 1 model locked until analysis-plan prerequisites are complete.")
