# Build an official Census 2000 county-to-PUMA population crosswalk.
#
# Source:
# Census 2000 5% PUMS Geographic Equivalency (PUMEQ5) files.
#
# The equivalency files report summary-level 780 PUMA totals and
# summary-level 781 PUMA-county (or county-part) population counts.
#
# This lets us aggregate a county-level treatment such as Craigslist entry
# into 2000-based PUMAs using Census 2000 population weights.
#
# IMPORTANT:
# This is a geographic aggregation device. It does not make county-level
# treatment quasi-random.

source(file.path("R","00_config.R"))

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

base_url <- "https://www2.census.gov/census_2000/datasets/PUMS/FivePercent"
dest_dir <- file.path(DIR_RAW,"census2000_pumeq")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_pumeq <- function(abbr, overwrite=FALSE) {
  state_dir <- unname(state_dirs[[abbr]])
  fname <- paste0("PUMEQ5-",abbr,".TXT")
  url <- paste(base_url,state_dir,fname,sep="/")
  dest <- file.path(dest_dir,fname)

  if (!file.exists(dest) || overwrite) {
    message("Downloading ",abbr," geographic equivalency file")
    utils::download.file(url,destfile=dest,mode="wb",quiet=FALSE)
  }

  data.frame(
    state_abbr=abbr,
    file=fname,
    bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    source_url=url,
    stringsAsFactors=FALSE
  )
}

manifest <- do.call(rbind,lapply(names(state_dirs),download_pumeq))
utils::write.csv(
  manifest,
  file.path(dest_dir,"manifest.csv"),
  row.names=FALSE
)

parse_pumeq <- function(path) {
  x <- readLines(path,warn=FALSE)

  # Data records begin with a blank followed by a 3-digit summary level.
  keep <- grepl("^ [0-9]{3} ",x)
  x <- x[keep]

  # Fixed-width positions documented in the PUMEQ file itself.
  out <- data.frame(
    summary_level = trimws(substr(x,1,4)),
    state_fips    = trimws(substr(x,6,7)),
    superpuma     = trimws(substr(x,9,13)),
    puma          = trimws(substr(x,15,19)),
    county_fips   = trimws(substr(x,21,23)),
    population    = suppressWarnings(as.numeric(trimws(substr(x,56,63)))),
    area_name     = trimws(substr(x,65,nchar(x))),
    stringsAsFactors=FALSE
  )

  out
}

parsed <- do.call(
  rbind,
  lapply(manifest$file,function(fname) {
    parse_pumeq(file.path(dest_dir,fname))
  })
)

puma_totals <- parsed[parsed$summary_level=="780",
                      c("state_fips","puma","population")]
names(puma_totals)[3] <- "puma_population"

county_parts <- parsed[
  parsed$summary_level=="781" &
    nzchar(parsed$county_fips),
  c("state_fips","puma","county_fips","population")
]
names(county_parts)[4] <- "county_part_population"

# New England can contain multiple 781 records for a PUMA-county pairing.
# Aggregate those records before calculating weights.
county_parts <- aggregate(
  county_part_population ~ state_fips + puma + county_fips,
  data=county_parts,
  FUN=sum,
  na.rm=TRUE
)

crosswalk <- merge(
  county_parts,
  puma_totals,
  by=c("state_fips","puma"),
  all.x=TRUE,
  sort=FALSE
)

crosswalk$county_geoid <- paste0(
  crosswalk$state_fips,
  crosswalk$county_fips
)

crosswalk$county_share_of_puma <-
  crosswalk$county_part_population / crosswalk$puma_population

# QA: county parts should account for the PUMA total.
qa <- aggregate(
  county_part_population ~ state_fips + puma + puma_population,
  data=crosswalk,
  FUN=sum,
  na.rm=TRUE
)
qa$population_gap <- qa$county_part_population - qa$puma_population
qa$relative_gap <- qa$population_gap / qa$puma_population

utils::write.csv(
  qa,
  file.path(DIR_INTERMEDIATE,"puma_county_crosswalk_qa.csv"),
  row.names=FALSE
)

bad <- qa[abs(qa$relative_gap) > 0.001,]

if (nrow(bad)>0L) {
  warning(
    nrow(bad),
    " PUMAs have >0.1% discrepancy between 780 total and summed 781 county parts. ",
    "Inspect QA before using the crosswalk."
  )
}

utils::write.csv(
  crosswalk,
  file.path(DIR_INTERMEDIATE,"county_to_puma2000_population_weights.csv"),
  row.names=FALSE
)

message("County-to-2000-PUMA crosswalk built from official Census equivalency files.")
