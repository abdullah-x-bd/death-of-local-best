# Audit CBP and NES schemas and NAICS continuity without estimating outcomes.
#
# This script must run after the raw download scripts. It records internal
# filenames and column headers by year. It does not select years based on
# observed treatment effects.

source(file.path("R","00_config.R"))

inspect_zip_csv <- function(path) {
  members <- utils::unzip(path,list=TRUE)$Name
  candidates <- members[
    grepl("\\.(csv|txt)$",members,ignore.case=TRUE)
  ]

  if (!length(candidates)) {
    return(data.frame(
      archive=basename(path),
      member=NA_character_,
      header=NA_character_,
      stringsAsFactors=FALSE
    ))
  }

  member <- candidates[1]
  con <- unz(path,member,open="rt")
  on.exit(close(con),add=TRUE)
  header <- readLines(con,n=1,warn=FALSE)

  data.frame(
    archive=basename(path),
    member=member,
    header=header,
    stringsAsFactors=FALSE
  )
}

roots <- c(
  cbp=file.path(DIR_RAW,"cbp_county"),
  nes=file.path(DIR_RAW,"nonemployer_county")
)

rows <- list()

for (dataset in names(roots)) {
  zips <- list.files(
    roots[[dataset]],
    pattern="\\.zip$",
    full.names=TRUE
  )

  if (!length(zips)) next

  tmp <- do.call(rbind,lapply(zips,inspect_zip_csv))
  tmp$dataset <- dataset
  rows[[dataset]] <- tmp
}

if (!length(rows)) {
  stop("No CBP/NES raw ZIP files found. Run download scripts first.")
}

audit <- do.call(rbind,rows)

utils::write.csv(
  audit,
  file.path(DIR_INTERMEDIATE,"cbp_nes_schema_audit.csv"),
  row.names=FALSE
)

message("Schema inventory written. NAICS harmonization remains locked.")
