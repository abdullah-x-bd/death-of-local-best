# Download the public replication package for the Craigslist newspaper study.
#
# Primary public source:
# Stanford GitLab repository for Gregory Martin et al.
#
# We pin the repository branch name here only for acquisition. Once a specific
# commit SHA is verified from the downloaded package, data provenance should
# record that SHA and future downloads should be pinned to it.

source(file.path("R","00_config.R"))

dest_dir <- file.path(DIR_RAW,"craigslist_replication")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

archive_url <- paste0(
  "https://code.stanford.edu/gjmartin/",
  "craigslist-replication-code-and-data/-/archive/main/",
  "craigslist-replication-code-and-data-main.zip"
)

archive_dest <- file.path(
  dest_dir,
  "craigslist-replication-code-and-data-main.zip"
)

if (!file.exists(archive_dest)) {
  message("Downloading Craigslist replication archive from Stanford GitLab")
  utils::download.file(
    archive_url,
    destfile=archive_dest,
    mode="wb",
    quiet=FALSE
  )
}

z <- utils::unzip(archive_dest,list=TRUE)

if (!nrow(z)) {
  stop("Downloaded Craigslist archive is not a valid ZIP.")
}

required_patterns <- c(
  "data/master_data_county_level\\.dta$",
  "data_construction/02__do_master_county_level\\.do$"
)

for (p in required_patterns) {
  if (!any(grepl(p,z$Name))) {
    stop("Expected replication component missing: ",p)
  }
}

manifest <- data.frame(
  source_url=archive_url,
  file=basename(archive_dest),
  bytes=file.info(archive_dest)$size,
  md5=unname(tools::md5sum(archive_dest)),
  downloaded_at=as.character(Sys.time()),
  stringsAsFactors=FALSE
)

utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest.csv"),
  row.names=FALSE
)

# Extract only into an ignored raw-data directory.
extract_dir <- file.path(dest_dir,"extracted")
if (!dir.exists(extract_dir)) dir.create(extract_dir,recursive=TRUE)

utils::unzip(archive_dest,exdir=extract_dir)

message("Craigslist replication package acquired.")
message("Next step: inspect variable labels and reproduce published first stage before extension outcomes.")
