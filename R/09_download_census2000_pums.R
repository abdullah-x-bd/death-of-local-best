# Download Census 2000 5% PUMS raw files directly from the U.S. Census Bureau.
#
# This script only acquires immutable raw files and computes checksums.
# Parsing is intentionally separate because the Census 2000 PUMS is fixed-width
# and contains household/person record structures that must be audited first.

source(file.path("R","00_config.R"))

base_url <- "https://www2.census.gov/census_2000/datasets/PUMS/FivePercent"

state_dirs <- c(
  AL="Alabama", AK="Alaska", AZ="Arizona", AR="Arkansas", CA="California",
  CO="Colorado", CT="Connecticut", DE="Delaware", DC="District_of_Columbia",
  FL="Florida", GA="Georgia", HI="Hawaii", ID="Idaho", IL="Illinois",
  IN="Indiana", IA="Iowa", KS="Kansas", KY="Kentucky", LA="Louisiana",
  ME="Maine", MD="Maryland", MA="Massachusetts", MI="Michigan", MN="Minnesota",
  MS="Mississippi", MO="Missouri", MT="Montana", NE="Nebraska", NV="Nevada",
  NH="New_Hampshire", NJ="New_Jersey", NM="New_Mexico", NY="New_York",
  NC="North_Carolina", ND="North_Dakota", OH="Ohio", OK="Oklahoma",
  OR="Oregon", PA="Pennsylvania", RI="Rhode_Island", SC="South_Carolina",
  SD="South_Dakota", TN="Tennessee", TX="Texas", UT="Utah", VT="Vermont",
  VA="Virginia", WA="Washington", WV="West_Virginia", WI="Wisconsin",
  WY="Wyoming"
)

dest_dir <- file.path(DIR_RAW,"census2000_pums5")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_one <- function(abbr, overwrite=FALSE) {
  d <- unname(state_dirs[[abbr]])
  fname <- paste0("all_",d,".zip")
  url <- paste(base_url,d,fname,sep="/")
  dest <- file.path(dest_dir,fname)

  if (!file.exists(dest) || overwrite) {
    message("Downloading ",abbr,": ",url)
    utils::download.file(url,destfile=dest,mode="wb",quiet=FALSE)
  }

  data.frame(
    state=abbr,
    file=fname,
    bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    source_url=url,
    stringsAsFactors=FALSE
  )
}

# Technical documentation is versioned alongside the raw data.
tech_url <- paste0(base_url,"/ALL_5%_PUMS_Tech_Docs.zip")
tech_dest <- file.path(dest_dir,"ALL_5%_PUMS_Tech_Docs.zip")
if (!file.exists(tech_dest)) {
  utils::download.file(tech_url,tech_dest,mode="wb",quiet=FALSE)
}

manifest <- do.call(rbind,lapply(names(state_dirs),download_one))
utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest.csv"),
  row.names=FALSE
)

message("Raw Census 2000 PUMS acquisition complete.")
message("Do not parse until the fixed-width record-layout audit is complete.")
