# Download verified national pilot series from FRED.
# These series are descriptive only and are not the causal design.

source(file.path("R", "00_config.R"))

series <- c(
  newspapers = "IPUJN51111W200000000",
  publishing = "IPUJN5111W200000000",
  independent_artists = "IPUSN7115W200000000"
)

download_fred_csv <- function(series_id, dest) {
  url <- sprintf(
    "https://fred.stlouisfed.org/graph/fredgraph.csv?id=%s",
    series_id
  )

  utils::download.file(url, destfile = dest, mode = "wb", quiet = FALSE)

  x <- utils::read.csv(dest, check.names = FALSE)

  if (ncol(x) != 2L) {
    stop("Unexpected FRED file structure for ", series_id)
  }

  names(x) <- c("date", "value")
  x$date <- as.Date(x$date)
  x$value <- suppressWarnings(as.numeric(x$value))
  x$series_id <- series_id
  x
}

all_series <- lapply(names(series), function(nm) {
  id <- series[[nm]]
  dest <- file.path(DIR_RAW, paste0("fred_", id, ".csv"))
  x <- download_fred_csv(id, dest)
  x$series_name <- nm
  x
})

pilot <- do.call(rbind, all_series)
pilot$year <- as.integer(format(pilot$date, "%Y"))

utils::write.csv(
  pilot,
  file.path(DIR_INTERMEDIATE, "pilot_industry_series.csv"),
  row.names = FALSE
)
