library(targets)

tar_option_set(
  packages = character(0),
  format = "rds"
)

list(
  tar_target(
    project_config,
    {
      source(file.path("R", "00_config.R"), local = TRUE)
      PROJECT_TITLE
    }
  )
)
