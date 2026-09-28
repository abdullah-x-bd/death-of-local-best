# Download annual County Business Patterns complete county files.
#
# Target period for Craigslist Study A: 1998-2010.
# Raw files are preserved unchanged and checksummed.
#
# Parsing and NAICS harmonization are separate steps because record layouts
# and NAICS vintages change over time.

source(file.path("R","00_config.R"))

years <- 1998:2010
dest_dir <- file.path(DIR_RAW,"cbp_county")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_one <- function(year,overwrite=FALSE) {
  yy <- sprintf("%02d",year %% 100)
  fname <- paste0("cbp",yy,"co.zip")
  url <- sprintf(
    "https://www2.census.gov/programs-surveys/cbp/datasets/%d/%s",
    year,fname
  )
  dest <- file.path(dest_dir,fname)

  if (!file.exists(dest) || overwrite) {
    message("Downloading CBP ",year)
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
  file.path(dest_dir,"manifest_1998_2010.csv"),
  row.names=FALSE
)

message("CBP raw county files downloaded. Do not pool years before NAICS/schema audit.")
