# Download annual Nonemployer Statistics county files.
#
# Target period for Craigslist Study A: 1997-2010.
# The relevant independent-work industry is NAICS 711510, but extraction is
# intentionally deferred until NAICS continuity and record layouts are audited.

source(file.path("R","00_config.R"))

years <- 1997:2010
dest_dir <- file.path(DIR_RAW,"nonemployer_county")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_one <- function(year,overwrite=FALSE) {
  yy <- sprintf("%02d",year %% 100)
  fname <- paste0("nonemp",yy,"co.zip")

  # Historical files are stored under a year-specific historical-datasets path.
  url <- sprintf(
    paste0(
      "https://www2.census.gov/programs-surveys/nonemployer-statistics/",
      "datasets/%d/historical-datasets/%s"
    ),
    year,fname
  )

  dest <- file.path(dest_dir,fname)

  if (!file.exists(dest) || overwrite) {
    message("Downloading NES ",year)
    utils::download.file(url,destfile=dest,mode="wb",quiet=FALSE)
  }

  members <- utils::unzip(dest,list=TRUE)$Name

  data.frame(
    year=year,
    file=fname,
    bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    members=paste(members,collapse=";"),
    source_url=url,
    stringsAsFactors=FALSE
  )
}

manifest <- do.call(rbind,lapply(years,download_one))

utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest_1997_2010.csv"),
  row.names=FALSE
)

message("NES raw county files downloaded. Do not pool years before NAICS/schema audit.")
