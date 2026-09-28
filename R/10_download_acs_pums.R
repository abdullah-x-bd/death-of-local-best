# Download annual ACS 1-year PUMS person files for the 2000-PUMA era.
#
# Census documents that ACS records through 2011 use 2000-based PUMAs.
# Beginning in 2012, ACS uses 2010-based PUMAs.
#
# This script therefore defaults to 2005-2011 and downloads person files only.
# It preserves the original ZIPs and records checksums.

source(file.path("R","00_config.R"))

years <- 2005:2011
states <- c(
  "ak","al","ar","az","ca","co","ct","dc","de","fl","ga","hi","ia","id","il",
  "in","ks","ky","la","ma","md","me","mi","mn","mo","ms","mt","nc","nd","ne",
  "nh","nj","nm","nv","ny","oh","ok","or","pa","ri","sc","sd","tn","tx","ut",
  "va","vt","wa","wi","wv","wy"
)

dest_dir <- file.path(DIR_RAW,"acs_pums")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_one <- function(year,state,overwrite=FALSE) {
  fname <- paste0("csv_p",state,".zip")
  url <- sprintf(
    "https://www2.census.gov/programs-surveys/acs/data/pums/%d/%s",
    year,fname
  )

  year_dir <- file.path(dest_dir,as.character(year))
  if (!dir.exists(year_dir)) dir.create(year_dir,recursive=TRUE)

  dest <- file.path(year_dir,fname)

  if (!file.exists(dest) || overwrite) {
    message("Downloading ",year," ",toupper(state),": ",url)
    utils::download.file(url,destfile=dest,mode="wb",quiet=FALSE)
  }

  members <- utils::unzip(dest,list=TRUE)
  csv_members <- members$Name[grepl("\\.csv$",members$Name,ignore.case=TRUE)]

  if (length(csv_members)<1L) {
    stop("No CSV member found in ",dest)
  }

  data.frame(
    year=year,
    state=toupper(state),
    file=fname,
    zip_bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    csv_members=paste(csv_members,collapse=";"),
    source_url=url,
    stringsAsFactors=FALSE
  )
}

grid <- expand.grid(
  year=years,
  state=states,
  stringsAsFactors=FALSE
)

manifest <- do.call(
  rbind,
  lapply(seq_len(nrow(grid)),function(i) {
    download_one(grid$year[i],grid$state[i])
  })
)

utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest_2005_2011.csv"),
  row.names=FALSE
)

message("ACS PUMS raw acquisition complete.")
