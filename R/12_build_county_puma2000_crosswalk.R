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

state_fips <- c(
  AL="01", AK="02", AZ="04", AR="05", CA="06", CO="08", CT="09", DE="10",
  DC="11", FL="12", GA="13", HI="15", ID="16", IL="17", IN="18", IA="19",
  KS="20", KY="21", LA="22", ME="23", MD="24", MA="25", MI="26", MN="27",
  MS="28", MO="29", MT="30", NE="31", NV="32", NH="33", NJ="34", NM="35",
  NY="36", NC="37", ND="38", OH="39", OK="40", OR="41", PA="42", RI="44",
  SC="45", SD="46", TN="47", TX="48", UT="49", VT="50", VA="51", WA="53",
  WV="54", WI="55", WY="56"
)

base_url <- "https://www2.census.gov/census_2000/datasets/PUMS/FivePercent"
dest_dir <- file.path(DIR_RAW,"census2000_pumeq")
if (!dir.exists(dest_dir)) dir.create(dest_dir,recursive=TRUE)

download_pumeq <- function(abbr, overwrite=FALSE) {
  state_dir <- unname(state_dirs[[abbr]])
  alpha_name <- paste0("PUMEQ5-",abbr,".TXT")
  numeric_name <- paste0("PUMEQ5-",unname(state_fips[[abbr]]),".TXT")

  candidates <- unique(c(
    paste(base_url,state_dir,alpha_name,sep="/"),
    paste(base_url,state_dir,numeric_name,sep="/")
  ))

  dest <- file.path(dest_dir,alpha_name)
  used_url <- NA_character_

  if (!file.exists(dest) || overwrite) {
    message("Downloading ",abbr," geographic equivalency file")

    errors <- character(0)
    success <- FALSE

    for (url in candidates) {
      ok <- tryCatch({
        tf <- tempfile(fileext=".txt")
        on.exit(unlink(tf),add=TRUE)
        utils::download.file(url,destfile=tf,mode="wb",quiet=TRUE)

        if (!file.exists(tf) || file.info(tf)$size < 100) {
          stop("download too small")
        }

        first <- readLines(tf,n=5,warn=FALSE)
        if (!length(first)) stop("empty text file")

        file.copy(tf,dest,overwrite=TRUE)
        used_url <- url
        TRUE
      },error=function(e) {
        errors <<- c(errors,paste(url,conditionMessage(e),sep=" :: "))
        FALSE
      })

      if (isTRUE(ok)) {
        success <- TRUE
        break
      }
    }

    if (!success) {
      stop(
        "No official Census PUMEQ URL succeeded for ",abbr,". Attempts:\n",
        paste(errors,collapse="\n")
      )
    }
  }

  data.frame(
    state_abbr=abbr,
    file=alpha_name,
    bytes=file.info(dest)$size,
    md5=unname(tools::md5sum(dest)),
    source_url=used_url,
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
