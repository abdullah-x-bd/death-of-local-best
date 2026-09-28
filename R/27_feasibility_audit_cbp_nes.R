# Feasibility audit for Study A administrative data.
#
# This script deliberately avoids estimating treatment effects or reporting
# outcome trends. It only checks whether the prespecified target industries
# exist at usable county coverage and how often exact employment is suppressed.

source(file.path("R","00_config.R"))

read_first_delimited_member <- function(zip_path) {
  members <- utils::unzip(zip_path,list=TRUE)$Name
  members <- members[grepl("\\.(csv|txt)$",members,ignore.case=TRUE)]
  if (!length(members)) stop("No delimited member found in ",zip_path)

  member <- members[1]
  con <- unz(zip_path,member,open="rt")
  on.exit(close(con),add=TRUE)

  x <- utils::read.csv(
    con,
    stringsAsFactors=FALSE,
    check.names=FALSE,
    na.strings=c("","NA")
  )

  names(x) <- toupper(trimws(names(x)))
  x
}

pick_name <- function(nms,candidates,required=TRUE) {
  hit <- candidates[candidates %in% nms]
  if (length(hit)) return(hit[1])
  if (required) stop("None of candidate columns found: ",paste(candidates,collapse=", "))
  NA_character_
}

clean_code <- function(x) {
  gsub("[^0-9]","",trimws(as.character(x)))
}

audit_cbp <- function(zip_path,year) {
  x <- read_first_delimited_member(zip_path)

  naics_col <- pick_name(names(x),c("NAICS","NAICS2007","NAICS2002","NAICS1997"))
  st_col <- pick_name(names(x),c("FIPSTATE","ST","STATE"))
  co_col <- pick_name(names(x),c("FIPSCTY","COUNTY","CTY"))
  emp_col <- pick_name(names(x),c("EMP"),required=FALSE)
  empflag_col <- pick_name(names(x),c("EMPFLAG"),required=FALSE)
  empnf_col <- pick_name(names(x),c("EMP_NF","EMP_F"),required=FALSE)

  code <- clean_code(x[[naics_col]])
  target <- c("511110","511120","511130")
  keep <- code %in% target

  z <- x[keep,,drop=FALSE]
  code <- code[keep]

  if (!nrow(z)) {
    return(data.frame(
      dataset="CBP",year=year,industry=target,n_rows=0,
      n_counties=0,n_emp_suppressed=NA_integer_,
      share_emp_suppressed=NA_real_
    ))
  }

  county <- paste0(
    sprintf("%02d",as.integer(z[[st_col]])),
    sprintf("%03d",as.integer(z[[co_col]]))
  )

  suppressed <- rep(FALSE,nrow(z))

  if (!is.na(empflag_col)) {
    flag <- trimws(as.character(z[[empflag_col]]))
    suppressed <- suppressed | nzchar(flag)
  }

  if (!is.na(empnf_col)) {
    nf <- toupper(trimws(as.character(z[[empnf_col]])))
    suppressed <- suppressed | nf %in% c("D","S")
  }

  if (!is.na(emp_col)) {
    emp_raw <- suppressWarnings(as.numeric(z[[emp_col]]))
    # A zero is not by itself called suppressed; publication flags decide.
    if (all(is.na(emp_raw))) warning("EMP could not be parsed in ",year)
  }

  do.call(rbind,lapply(target,function(k) {
    idx <- which(code==k)
    data.frame(
      dataset="CBP",
      year=year,
      industry=k,
      n_rows=length(idx),
      n_counties=length(unique(county[idx])),
      n_emp_suppressed=sum(suppressed[idx],na.rm=TRUE),
      share_emp_suppressed=if(length(idx)) mean(suppressed[idx],na.rm=TRUE) else NA_real_,
      stringsAsFactors=FALSE
    )
  }))
}

audit_nes <- function(zip_path,year) {
  x <- read_first_delimited_member(zip_path)

  naics_col <- pick_name(
    names(x),
    c("NAICS","NAICS2007","NAICS2002","NAICS1997","NAICS2012")
  )
  st_col <- pick_name(names(x),c("STATE","ST","FIPSTATE"))
  co_col <- pick_name(names(x),c("COUNTY","FIPSCTY","CTY"))

  nestab_flag <- pick_name(
    names(x),
    c("NESTAB_F","NESTABFLAG","ESTAB_F"),
    required=FALSE
  )
  receipts_flag <- pick_name(
    names(x),
    c("NRCPTOT_F","RCPTOT_F"),
    required=FALSE
  )

  code <- clean_code(x[[naics_col]])
  target <- c("711510","711130","541430")
  keep <- code %in% target

  z <- x[keep,,drop=FALSE]
  code <- code[keep]

  if (!nrow(z)) {
    return(data.frame(
      dataset="NES",year=year,industry=target,n_rows=0,
      n_counties=0,n_estab_flagged=NA_integer_,
      n_receipts_flagged=NA_integer_
    ))
  }

  county <- paste0(
    sprintf("%02d",as.integer(z[[st_col]])),
    sprintf("%03d",as.integer(z[[co_col]]))
  )

  flagged_est <- flagged_rec <- rep(FALSE,nrow(z))

  if (!is.na(nestab_flag)) {
    flagged_est <- nzchar(trimws(as.character(z[[nestab_flag]])))
  }
  if (!is.na(receipts_flag)) {
    flagged_rec <- nzchar(trimws(as.character(z[[receipts_flag]])))
  }

  do.call(rbind,lapply(target,function(k) {
    idx <- which(code==k)
    data.frame(
      dataset="NES",
      year=year,
      industry=k,
      n_rows=length(idx),
      n_counties=length(unique(county[idx])),
      n_estab_flagged=sum(flagged_est[idx],na.rm=TRUE),
      n_receipts_flagged=sum(flagged_rec[idx],na.rm=TRUE),
      stringsAsFactors=FALSE
    )
  }))
}

cbp_dir <- file.path(DIR_RAW,"cbp_county")
nes_dir <- file.path(DIR_RAW,"nonemployer_county")

cbp_files <- list.files(cbp_dir,pattern="^cbp[0-9]{2}co\\.zip$",full.names=TRUE)
nes_files <- list.files(nes_dir,pattern="^nonemp[0-9]{2}co\\.zip$",full.names=TRUE)

if (!length(cbp_files)) stop("No CBP files found.")
if (!length(nes_files)) stop("No NES files found.")

year_from_file <- function(path) {
  yy <- as.integer(sub(".*?([0-9]{2})co\\.zip$","\\1",basename(path)))
  ifelse(yy>=90,1900+yy,2000+yy)
}

cbp_audit <- do.call(rbind,lapply(cbp_files,function(f) {
  audit_cbp(f,year_from_file(f))
}))

nes_audit <- do.call(rbind,lapply(nes_files,function(f) {
  audit_nes(f,year_from_file(f))
}))

utils::write.csv(
  cbp_audit,
  file.path(DIR_INTERMEDIATE,"study_a_cbp_feasibility.csv"),
  row.names=FALSE
)

utils::write.csv(
  nes_audit,
  file.path(DIR_INTERMEDIATE,"study_a_nes_feasibility.csv"),
  row.names=FALSE
)

# Coverage-only console summary. No treatment effects or outcome totals.
print(cbp_audit)
print(nes_audit)
