#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ipumsr)
  library(data.table)
  library(haven)
  library(jsonlite)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript analysis/01_ipums_stage1.R <ddi.xml> <data.dat.gz> <outdir>")
}

ddi_file <- args[[1]]
data_file <- args[[2]]
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
partial_dir <- file.path(outdir, "_partials")
dir.create(partial_dir, recursive = TRUE, showWarnings = FALSE)

message("Reading DDI: ", ddi_file)
ddi <- read_ipums_ddi(ddi_file)
var_info <- as.data.table(ipums_var_info(ddi))

# Preserve a flat variable inventory without list-valued label columns.
flat_cols <- names(var_info)[!vapply(var_info, is.list, logical(1))]
fwrite(var_info[, ..flat_cols], file.path(outdir, "variable_inventory.csv"))

requested <- c(
  "YEAR","SAMPLE","SERIAL","PERNUM","PERWT",
  "AGE","SEX","RACE","HISPAN","EDUC","EDUCD",
  "EMPSTAT","EMPSTATD","LABFORCE",
  "OCC","OCC1990","OCC2010","OCCSOC",
  "IND","IND1990","INDNAICS",
  "CLASSWKR","CLASSWKRD",
  "INCWAGE","INCTOT","UHRSWORK","WKSWORK2","WORKEDYR",
  "STATEFIP","PUMA","MET2013","METAREA","PWPUMA","PWPUMA00",
  "MIGRATE1","MIGPUMA1","MIGPLAC1"
)

available <- var_info$var_name
coverage <- data.table(
  variable = requested,
  present = requested %in% available
)
fwrite(coverage, file.path(outdir, "requested_variable_coverage.csv"))

essential <- c("YEAR","SAMPLE","PERWT","AGE","EMPSTAT","STATEFIP")
missing_essential <- setdiff(essential, available)
if (length(missing_essential) > 0) {
  stop("Missing essential variables: ", paste(missing_essential, collapse = ", "))
}

analysis_vars <- intersect(
  c("YEAR","SAMPLE","PERWT","AGE","EMPSTAT","OCC1990","OCC2010",
    "CLASSWKR","INCWAGE","UHRSWORK","STATEFIP"),
  available
)

message("Streaming variables: ", paste(analysis_vars, collapse = ", "))

clean_labelled_numeric <- function(v) {
  out <- as.numeric(v)
  labs <- attr(v, "labels", exact = TRUE)
  if (!is.null(labs) && length(labs) > 0) {
    nm <- names(labs)
    bad <- unname(labs[
      grepl("N/A|N\\.I\\.U|NIU|not in universe|missing", nm, ignore.case = TRUE)
    ])
    if (length(bad) > 0) {
      out[out %in% bad] <- NA_real_
    }
  }
  out
}

append_dt <- function(dt, filename) {
  if (is.null(dt) || nrow(dt) == 0) return(invisible(NULL))
  path <- file.path(partial_dir, filename)
  fwrite(dt, path, append = file.exists(path), col.names = !file.exists(path))
}

chunk_counter <- 0L
rows_seen <- 0

callback <- IpumsSideEffectCallback$new(function(x, pos) {
  chunk_counter <<- chunk_counter + 1L
  rows_seen <<- rows_seen + nrow(x)

  dt <- as.data.table(x)

  dt[, .w := as.numeric(PERWT)]
  dt[is.na(.w) | .w < 0, .w := 0]

  dt[, .age := as.numeric(AGE)]
  dt[, .working_age := .age >= 16 & .age <= 64]
  dt[, .prime_age := .age >= 25 & .age <= 54]
  dt[, .young := .age >= 20 & .age <= 29]

  emp_label <- as.character(haven::as_factor(dt$EMPSTAT, levels = "labels"))
  dt[, .employed := grepl("employed", emp_label, ignore.case = TRUE) &
                    !grepl("unemployed", emp_label, ignore.case = TRUE)]
  dt[, .unemployed := grepl("unemployed", emp_label, ignore.case = TRUE)]
  dt[, .labor_force := .employed | .unemployed]

  if ("CLASSWKR" %in% names(dt)) {
    cw_label <- as.character(haven::as_factor(dt$CLASSWKR, levels = "labels"))
    dt[, .selfemp := grepl("self.?employ", cw_label, ignore.case = TRUE)]
  } else {
    dt[, .selfemp := FALSE]
  }

  if ("INCWAGE" %in% names(dt)) {
    dt[, .wage := clean_labelled_numeric(INCWAGE)]
  } else {
    dt[, .wage := NA_real_]
  }

  if ("UHRSWORK" %in% names(dt)) {
    dt[, .hours := clean_labelled_numeric(UHRSWORK)]
  } else {
    dt[, .hours := NA_real_]
  }

  sy <- dt[, .(
    n_persons = .N,
    person_weight = sum(.w, na.rm = TRUE),
    working_age_weight = sum(.w[.working_age], na.rm = TRUE),
    prime_age_weight = sum(.w[.prime_age], na.rm = TRUE),
    labor_force_weight = sum(.w[.working_age & .labor_force], na.rm = TRUE),
    employed_weight = sum(.w[.working_age & .employed], na.rm = TRUE),
    unemployed_weight = sum(.w[.working_age & .unemployed], na.rm = TRUE),
    young_20_29_employed_weight = sum(.w[.young & .employed], na.rm = TRUE),
    selfemployed_weight = sum(.w[.working_age & .employed & .selfemp], na.rm = TRUE),
    wage_sum_w = sum(.w * .wage * (.working_age & .employed), na.rm = TRUE),
    wage_weight = sum(.w[.working_age & .employed & !is.na(.wage)], na.rm = TRUE),
    hours_sum_w = sum(.w * .hours * (.working_age & .employed), na.rm = TRUE),
    hours_weight = sum(.w[.working_age & .employed & !is.na(.hours)], na.rm = TRUE)
  ), by = .(YEAR, SAMPLE)]
  append_dt(sy, "sample_year.csv")

  st <- dt[.working_age == TRUE, .(
    n_persons = .N,
    person_weight = sum(.w, na.rm = TRUE),
    labor_force_weight = sum(.w[.labor_force], na.rm = TRUE),
    employed_weight = sum(.w[.employed], na.rm = TRUE),
    unemployed_weight = sum(.w[.unemployed], na.rm = TRUE),
    selfemployed_weight = sum(.w[.employed & .selfemp], na.rm = TRUE)
  ), by = .(YEAR, STATEFIP)]
  append_dt(st, "state_year.csv")

  if ("OCC1990" %in% names(dt)) {
    occ90 <- dt[.working_age & .employed & as.numeric(OCC1990) > 0, .(
      n_workers = .N,
      worker_weight = sum(.w, na.rm = TRUE),
      young_20_29_weight = sum(.w[.young], na.rm = TRUE),
      selfemployed_weight = sum(.w[.selfemp], na.rm = TRUE),
      wage_sum_w = sum(.w * .wage, na.rm = TRUE),
      wage_weight = sum(.w[!is.na(.wage)], na.rm = TRUE),
      hours_sum_w = sum(.w * .hours, na.rm = TRUE),
      hours_weight = sum(.w[!is.na(.hours)], na.rm = TRUE)
    ), by = .(YEAR, OCC1990)]
    append_dt(occ90, "occupation_year_occ1990.csv")
  }

  if ("OCC2010" %in% names(dt)) {
    occ10 <- dt[.working_age & .employed & as.numeric(OCC2010) > 0, .(
      n_workers = .N,
      worker_weight = sum(.w, na.rm = TRUE),
      young_20_29_weight = sum(.w[.young], na.rm = TRUE),
      selfemployed_weight = sum(.w[.selfemp], na.rm = TRUE),
      wage_sum_w = sum(.w * .wage, na.rm = TRUE),
      wage_weight = sum(.w[!is.na(.wage)], na.rm = TRUE),
      hours_sum_w = sum(.w * .hours, na.rm = TRUE),
      hours_weight = sum(.w[!is.na(.hours)], na.rm = TRUE)
    ), by = .(YEAR, OCC2010)]
    append_dt(occ10, "occupation_year_occ2010.csv")
  }

  if (chunk_counter %% 10L == 0L) {
    message("Processed chunks: ", chunk_counter, "; rows: ", format(rows_seen, big.mark = ","))
  }

  invisible(NULL)
})

read_ipums_micro_chunked(
  ddi = ddi,
  callback = callback,
  chunk_size = 500000,
  vars = analysis_vars,
  data_file = data_file,
  verbose = TRUE,
  var_attrs = c("val_labels")
)

sum_cols <- function(dt, by_cols, metric_cols) {
  dt[, lapply(.SD, sum, na.rm = TRUE), by = by_cols, .SDcols = metric_cols]
}

sy_raw <- fread(file.path(partial_dir, "sample_year.csv"))
sy_metrics <- setdiff(names(sy_raw), c("YEAR","SAMPLE"))
sy <- sum_cols(sy_raw, c("YEAR","SAMPLE"), sy_metrics)
sy[, employment_population_rate := fifelse(working_age_weight > 0, employed_weight / working_age_weight, NA_real_)]
sy[, unemployment_rate := fifelse(labor_force_weight > 0, unemployed_weight / labor_force_weight, NA_real_)]
sy[, labor_force_participation := fifelse(working_age_weight > 0, labor_force_weight / working_age_weight, NA_real_)]
sy[, selfemployment_share := fifelse(employed_weight > 0, selfemployed_weight / employed_weight, NA_real_)]
sy[, mean_nominal_wage := fifelse(wage_weight > 0, wage_sum_w / wage_weight, NA_real_)]
sy[, mean_weekly_hours := fifelse(hours_weight > 0, hours_sum_w / hours_weight, NA_real_)]
setorder(sy, YEAR, SAMPLE)
fwrite(sy, file.path(outdir, "sample_year_summary.csv"))

st_raw <- fread(file.path(partial_dir, "state_year.csv"))
st_metrics <- setdiff(names(st_raw), c("YEAR","STATEFIP"))
st <- sum_cols(st_raw, c("YEAR","STATEFIP"), st_metrics)
st[, employment_population_rate := fifelse(person_weight > 0, employed_weight / person_weight, NA_real_)]
st[, unemployment_rate := fifelse(labor_force_weight > 0, unemployed_weight / labor_force_weight, NA_real_)]
st[, selfemployment_share := fifelse(employed_weight > 0, selfemployed_weight / employed_weight, NA_real_)]
setorder(st, YEAR, STATEFIP)
fwrite(st, file.path(outdir, "state_year_summary.csv"))

aggregate_occ <- function(filename, occ_col, outname) {
  path <- file.path(partial_dir, filename)
  if (!file.exists(path)) return(invisible(NULL))
  raw <- fread(path)
  metrics <- setdiff(names(raw), c("YEAR", occ_col))
  out <- sum_cols(raw, c("YEAR", occ_col), metrics)
  out[, young_20_29_share := fifelse(worker_weight > 0, young_20_29_weight / worker_weight, NA_real_)]
  out[, selfemployment_share := fifelse(worker_weight > 0, selfemployed_weight / worker_weight, NA_real_)]
  out[, mean_nominal_wage := fifelse(wage_weight > 0, wage_sum_w / wage_weight, NA_real_)]
  out[, mean_weekly_hours := fifelse(hours_weight > 0, hours_sum_w / hours_weight, NA_real_)]
  setorderv(out, c("YEAR", occ_col))
  fwrite(out, file.path(outdir, outname))
}

aggregate_occ("occupation_year_occ1990.csv", "OCC1990", "occupation_year_occ1990.csv")
aggregate_occ("occupation_year_occ2010.csv", "OCC2010", "occupation_year_occ2010.csv")

qa <- list(
  created_utc = format(Sys.time(), tz = "UTC", usetz = TRUE),
  ddi_file = basename(ddi_file),
  data_file = basename(data_file),
  chunks_processed = chunk_counter,
  rows_processed = rows_seen,
  analysis_variables = analysis_vars,
  requested_variables_present = as.list(setNames(coverage$present, coverage$variable)),
  years_observed = sort(unique(sy$YEAR)),
  sample_year_rows = nrow(sy),
  state_year_rows = nrow(st),
  note = paste(
    "Stage 1 is ingestion and descriptive QA only.",
    "Nominal wage means are not inflation-adjusted.",
    "No confirmatory causal coefficient is estimated here."
  )
)
write_json(qa, file.path(outdir, "qa_report.json"), pretty = TRUE, auto_unbox = TRUE)

unlink(partial_dir, recursive = TRUE)
message("Stage 1 complete. Rows processed: ", format(rows_seen, big.mark = ","))
