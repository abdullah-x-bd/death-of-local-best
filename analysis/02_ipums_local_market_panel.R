#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ipumsr)
  library(data.table)
  library(haven)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) stop("Usage: 02_ipums_local_market_panel.R <ddi.xml> <data.dat.gz> <outdir>")

ddi_file <- args[[1]]
data_file <- args[[2]]
outdir <- args[[3]]
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
tmp <- file.path(outdir, "_partials")
dir.create(tmp, recursive = TRUE, showWarnings = FALSE)

ddi <- read_ipums_ddi(ddi_file)
vi <- as.data.table(ipums_var_info(ddi))
avail <- vi$var_name

essential <- c("YEAR","PERWT","AGE","EMPSTAT","STATEFIP")
miss <- setdiff(essential, avail)
if (length(miss)) stop("Missing essential variables: ", paste(miss, collapse=", "))

occvars <- intersect(c("OCC2010","OCC1990"), avail)
if (!length(occvars)) stop("Neither OCC2010 nor OCC1990 is available.")

geovars <- intersect(c("STATEFIP","MET2013","METAREA"), avail)
readvars <- unique(c(essential, occvars, geovars, intersect(c("CLASSWKR"), avail)))

append_dt <- function(dt, name) {
  if (is.null(dt) || !nrow(dt)) return(invisible(NULL))
  p <- file.path(tmp, name)
  fwrite(dt, p, append=file.exists(p), col.names=!file.exists(p))
}

valid_geo <- function(v) {
  lab <- as.character(haven::as_factor(v, levels="labels"))
  num <- as.numeric(v)
  ok <- !is.na(num) & num > 0
  ok <- ok & !grepl("not in metropolitan|not identifiable|n/a|niu|missing", lab, ignore.case=TRUE)
  ok[is.na(ok)] <- FALSE
  ok
}

chunk <- 0L
rows <- 0
cb <- IpumsSideEffectCallback$new(function(x, pos) {
  chunk <<- chunk + 1L
  rows <<- rows + nrow(x)
  dt <- as.data.table(x)
  dt[, .w := as.numeric(PERWT)]
  dt[is.na(.w) | .w < 0, .w := 0]
  age <- as.numeric(dt$AGE)
  emp_lab <- as.character(haven::as_factor(dt$EMPSTAT, levels="labels"))
  dt[, .emp := age >= 16 & age <= 64 &
               grepl("employed", emp_lab, ignore.case=TRUE) &
               !grepl("unemployed", emp_lab, ignore.case=TRUE)]
  dt[, .young := age >= 20 & age <= 29]

  if ("CLASSWKR" %in% names(dt)) {
    cw <- as.character(haven::as_factor(dt$CLASSWKR, levels="labels"))
    dt[, .selfemp := grepl("self.?employ", cw, ignore.case=TRUE)]
  } else {
    dt[, .selfemp := FALSE]
  }

  for (occ in occvars) {
    ov <- as.numeric(dt[[occ]])
    occ_ok <- !is.na(ov) & ov > 0 & dt$.emp

    # Stable state-level concentration series across the entire sample.
    z <- dt[occ_ok, .(
      n_workers=.N,
      worker_weight=sum(.w, na.rm=TRUE),
      young_weight=sum(.w[.young], na.rm=TRUE),
      selfemp_weight=sum(.w[.selfemp], na.rm=TRUE)
    ), by=c("YEAR","STATEFIP",occ)]
    append_dt(z, paste0("cells_STATEFIP_",occ,".csv"))

    for (geo in intersect(c("MET2013","METAREA"), geovars)) {
      gok <- valid_geo(dt[[geo]])
      z <- dt[occ_ok & gok, .(
        n_workers=.N,
        worker_weight=sum(.w, na.rm=TRUE),
        young_weight=sum(.w[.young], na.rm=TRUE),
        selfemp_weight=sum(.w[.selfemp], na.rm=TRUE)
      ), by=c("YEAR",geo,occ)]
      append_dt(z, paste0("cells_",geo,"_",occ,".csv"))
    }
  }

  if (chunk %% 10L == 0L) message("Local-market chunks: ", chunk, "; rows: ", format(rows,big.mark=","))
  invisible(NULL)
})

read_ipums_micro_chunked(
  ddi=ddi,
  callback=cb,
  chunk_size=500000,
  vars=readvars,
  data_file=data_file,
  verbose=TRUE,
  var_attrs=c("val_labels")
)

concentration <- function(path, geo, occ, label) {
  if (!file.exists(path)) return(NULL)
  d <- fread(path)
  d <- d[, .(
    n_workers=sum(n_workers),
    worker_weight=sum(worker_weight),
    young_weight=sum(young_weight),
    selfemp_weight=sum(selfemp_weight)
  ), by=c("YEAR",geo,occ)]

  # Concentration statistics are calculated using all internal cells.
  # Granular cells themselves are not exported.
  setorderv(d, c("YEAR",occ,"worker_weight"), c(1,1,-1))
  out <- d[, {
    w <- worker_weight
    total <- sum(w, na.rm=TRUE)
    s <- if (total > 0) w / total else rep(NA_real_, .N)
    n <- .N
    list(
      geography=label,
      total_worker_weight=total,
      market_count=n,
      markets_n20=sum(n_workers >= 20),
      hhi=sum(s^2, na.rm=TRUE),
      top1_share=sum(head(s,1), na.rm=TRUE),
      top5_share=sum(head(s,5), na.rm=TRUE),
      top10_share=sum(head(s,10), na.rm=TRUE),
      outside_top10_share=1-sum(head(s,10), na.rm=TRUE),
      young_20_29_share=if (total>0) sum(young_weight)/total else NA_real_,
      selfemployment_share=if (total>0) sum(selfemp_weight)/total else NA_real_
    )
  }, by=c("YEAR",occ)]
  out
}

outs <- list()
for (occ in occvars) {
  for (geo in intersect(c("STATEFIP","MET2013","METAREA"), geovars)) {
    p <- file.path(tmp, paste0("cells_",geo,"_",occ,".csv"))
    z <- concentration(p, geo, occ, geo)
    if (!is.null(z)) outs[[length(outs)+1L]] <- z
  }
}
final <- rbindlist(outs, fill=TRUE)
if (!nrow(final)) stop("No local-market concentration output was produced.")
setorderv(final, c("geography","YEAR"))
fwrite(final, file.path(outdir, "occupation_geographic_concentration.csv"))

meta <- data.table(
  rows_processed=rows,
  chunks_processed=chunk,
  occupation_codings=paste(occvars, collapse=","),
  geography_codings=paste(geovars, collapse=","),
  note="MET2013 and METAREA are retained as separate series; no cross-definition pooling is performed."
)
fwrite(meta, file.path(outdir, "local_market_qa.csv"))
unlink(tmp, recursive=TRUE)

message("Stage 2 local-market construction complete.")
