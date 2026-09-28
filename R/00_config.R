# Project-wide configuration

options(stringsAsFactors = FALSE)
options(scipen = 999)

PROJECT_TITLE <- "From Local Scarcity to Machine Abundance: Digital Markets and the Erosion of Competence Rents"

DIR_RAW <- file.path("data", "raw")
DIR_INTERMEDIATE <- file.path("data", "intermediate")
DIR_DERIVED <- file.path("data", "derived")
DIR_TABLES <- file.path("output", "tables")
DIR_FIGURES <- file.path("output", "figures")

for (d in c(DIR_RAW, DIR_INTERMEDIATE, DIR_DERIVED, DIR_TABLES, DIR_FIGURES)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# Do not place API keys in version control.
# If a Census API key is needed, read it from Sys.getenv("CENSUS_API_KEY").
