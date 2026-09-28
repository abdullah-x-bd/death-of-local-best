# Reproduce the initial national descriptive facts.
# Nothing in this script is causal.

source(file.path("R", "00_config.R"))

path <- file.path(DIR_INTERMEDIATE, "pilot_industry_series.csv")

if (!file.exists(path)) {
  stop("Run R/01_download_pilot_series.R first")
}

d <- utils::read.csv(path)

pct_change <- function(start, end) 100 * (end / start - 1)

annualized_log_trend <- function(df, start_year, end_year) {
  z <- df[df$year >= start_year & df$year <= end_year & is.finite(df$value) & df$value > 0, ]
  fit <- stats::lm(log(value) ~ year, data = z)
  100 * (exp(stats::coef(fit)[["year"]]) - 1)
}

series_names <- unique(d$series_name)

summary_rows <- lapply(series_names, function(s) {
  z <- d[d$series_name == s, ]

  v2001 <- z$value[z$year == 2001]
  v2025 <- z$value[z$year == 2025]

  data.frame(
    series = s,
    value_2001 = v2001,
    value_2025 = v2025,
    pct_change_2001_2025 = pct_change(v2001, v2025),
    log_trend_1987_2000_pct = annualized_log_trend(z, 1987, 2000),
    log_trend_2001_2019_pct = annualized_log_trend(z, 2001, 2019),
    log_trend_2001_2025_pct = annualized_log_trend(z, 2001, 2025)
  )
})

out <- do.call(rbind, summary_rows)

utils::write.csv(
  out,
  file.path(DIR_TABLES, "pilot_industry_descriptives.csv"),
  row.names = FALSE
)

print(out)
