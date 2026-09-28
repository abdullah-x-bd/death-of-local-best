# Audit ACS person-file schemas without constructing outcomes.
#
# This script lists column names by year/state and checks whether candidate
# variables exist consistently. It does not decide harmonization rules.

source(file.path("R","00_config.R"))

root <- file.path(DIR_RAW,"acs_pums")

zip_files <- list.files(
  root,
  pattern="^csv_p[a-z]{2}\\.zip$",
  recursive=TRUE,
  full.names=TRUE
)

if (!length(zip_files)) {
  stop("No ACS PUMS ZIP files found. Run R/10_download_acs_pums.R first.")
}

read_header_from_zip <- function(z) {
  members <- utils::unzip(z,list=TRUE)$Name
  csv_member <- members[grepl("\\.csv$",members,ignore.case=TRUE)][1]

  con <- unz(z,csv_member,open="rt")
  on.exit(close(con),add=TRUE)
  header <- readLines(con,n=1L,warn=FALSE)

  # Header is ordinary CSV. strsplit is sufficient because Census variable
  # names themselves do not contain commas.
  cols <- strsplit(header,",",fixed=TRUE)[[1]]
  gsub('^"|"$',"",cols)
}

rows <- lapply(zip_files,function(z) {
  cols <- read_header_from_zip(z)
  year <- as.integer(basename(dirname(z)))
  state <- toupper(sub("^csv_p([a-z]{2})\\.zip$","\\1",basename(z)))

  data.frame(
    year=year,
    state=state,
    variable=cols,
    stringsAsFactors=FALSE
  )
})

schema <- do.call(rbind,rows)

utils::write.csv(
  schema,
  file.path(DIR_INTERMEDIATE,"acs_schema_inventory.csv"),
  row.names=FALSE
)

candidate_regex <- paste(
  c(
    "^PUMA$","^OCCP","^PWGTP$","^AGEP$","^COW$","^ESR$",
    "^WAGP$","^SEMP$","^PINCP$","^WKHP$","^WKW","^MIG",
    "^SCHL$","^ADJINC$","^INDP"
  ),
  collapse="|"
)

candidate <- schema[grepl(candidate_regex,schema$variable),]
utils::write.csv(
  unique(candidate),
  file.path(DIR_INTERMEDIATE,"acs_candidate_variable_inventory.csv"),
  row.names=FALSE
)

message("Schema audit written. No harmonization decisions were made.")
