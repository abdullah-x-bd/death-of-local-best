# Download annual Nonemployer Statistics county files.
#
# Target period for Craigslist Study A: 1997-2010.
#
# Census has moved historical NES files across multiple archive structures.
# This script therefore tries a documented sequence of official Census URLs,
# records the URL that succeeds, preserves the original ZIP, and computes an MD5.
#
# Extraction of NAICS 711510 is intentionally deferred until schema and
# industry-continuity audits are complete.

source(file.path("R","00_config.R"))

years <- 1997:2010
dest_dir <- file.path(DIR_RAW,"nonemployer_county")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

candidate_urls <- function(year) {
  yy <- sprintf("%02d",year %% 100)
  lower <- paste0("nonemp",yy,"co.zip")
  upper <- paste0("Nonemp",yy,"co.zip")

  unique(c(
    # Current Census historical-dataset mirror used for some vintages.
    sprintf(
      paste0(
        "https://www2.census.gov/programs-surveys/nonemployer-statistics/",
        "datasets/%d/historical-datasets/%s"
      ),
      year,lower
    ),

    # Original annual economic-data archive, common for 2002-2010.
    sprintf(
      "https://www2.census.gov/econ%d/NONEMPLOYER_CSV/%s",
      year,lower
    ),
    sprintf(
      "https://www2.census.gov/econ%d/NONEMPLOYER_CSV/%s",
      year,upper
    ),

    # Legacy 2001-and-earlier archive.
    sprintf(
      "https://www2.census.gov/Econ2001_And_Earlier/NONEMPLOYER_CSV/%s",
      upper
    ),
    sprintf(
      "https://www2.census.gov/Econ2001_And_Earlier/NONEMPLOYER_CSV/%s",
      lower
    )
  ))
}

download_first_available <- function(urls,dest) {
  errors <- character(0)

  for (url in urls) {
    ok <- tryCatch({
      tf <- tempfile(fileext=".zip")
      on.exit(unlink(tf),add=TRUE)
      utils::download.file(url,destfile=tf,mode="wb",quiet=TRUE)

      # Reject empty/error-page downloads.
      if (!file.exists(tf) || file.info(tf)$size < 1000) {
        stop("download too small")
      }

      # Validate that the file is actually a ZIP archive before accepting it.
      z <- try(utils::unzip(tf,list=TRUE),silent=TRUE)
      if (inherits(z,"try-error") || nrow(z)<1L) {
        stop("not a valid ZIP archive")
      }

      file.copy(tf,dest,overwrite=TRUE)
      TRUE
    },error=function(e) {
      errors <<- c(errors,paste(url,conditionMessage(e),sep=" :: "))
      FALSE
    })

    if (isTRUE(ok)) return(url)
  }

  stop(
    "No official Census NES URL succeeded. Attempts:\n",
    paste(errors,collapse="\n")
  )
}

download_one <- function(year,overwrite=FALSE) {
  yy <- sprintf("%02d",year %% 100)
  fname <- paste0("nonemp",yy,"co.zip")
  dest <- file.path(dest_dir,fname)

  used_url <- NA_character_

  if (!file.exists(dest) || overwrite) {
    message("Downloading NES ",year)
    used_url <- download_first_available(candidate_urls(year),dest)
  } else {
    # Recover the first canonical candidate only as metadata if the file
    # predates this manifest. A later run with overwrite=TRUE verifies source.
    used_url <- NA_character_
  }

  members <- utils::unzip(dest,list=TRUE)$Name

  data.frame(
    year=year,
    file=fname,
    bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    members=paste(members,collapse=";"),
    source_url=used_url,
    stringsAsFactors=FALSE
  )
}

manifest <- do.call(rbind,lapply(years,download_one))

utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest_1997_2010.csv"),
  row.names=FALSE
)

message("NES raw county files acquired from official Census archives.")
message("Do not pool years before NAICS/schema audit.")
