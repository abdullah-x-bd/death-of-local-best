#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ipumsr)
  library(data.table)
  library(haven)
  library(jsonlite)
})

args <- commandArgs(trailingOnly=TRUE)
if (length(args)<3) stop("Usage: 07_ipums_puma_panel.R <ddi.xml> <data.dat.gz> <outdir>")
ddi_file<-args[[1]]
data_file<-args[[2]]
outdir<-args[[3]]
dir.create(outdir,recursive=TRUE,showWarnings=FALSE)
tmp<-file.path(outdir,"_partials")
dir.create(tmp,recursive=TRUE,showWarnings=FALSE)

ddi<-read_ipums_ddi(ddi_file)
vi<-as.data.table(ipums_var_info(ddi))
avail<-vi$var_name
need<-c("YEAR","STATEFIP","PUMA","PERWT","AGE","EMPSTAT","OCC2010","CLASSWKR","INCWAGE","UHRSWORK")
miss<-setdiff(need,avail)
if(length(miss)) stop("Missing variables: ",paste(miss,collapse=", "))

clean_num<-function(v){
  out<-as.numeric(v)
  labs<-attr(v,"labels",exact=TRUE)
  if(!is.null(labs)&&length(labs)){
    nm<-names(labs)
    bad<-unname(labs[grepl("N/A|N\\.I\\.U|NIU|not in universe|missing",nm,ignore.case=TRUE)])
    if(length(bad)) out[out %in% bad]<-NA_real_
  }
  out
}
puma_vintage<-function(year){
  fifelse(year==1990,"1990",
    fifelse(year>=2000 & year<=2011,"2000",
      fifelse(year>=2012 & year<=2021,"2010",
        fifelse(year>=2022,"2020",NA_character_))))
}
append_dt<-function(dt,name){
  if(is.null(dt)||!nrow(dt)) return(invisible(NULL))
  p<-file.path(tmp,name)
  fwrite(dt,p,append=file.exists(p),col.names=!file.exists(p))
}

chunks<-0L
rows<-0
cb<-IpumsSideEffectCallback$new(function(x,pos){
  chunks<<-chunks+1L
  rows<<-rows+nrow(x)
  d<-as.data.table(x)
  d[,YEAR:=as.integer(YEAR)]
  d[,STATEFIP:=as.integer(STATEFIP)]
  d[,PUMA:=as.integer(PUMA)]
  d[,OCC2010:=as.integer(OCC2010)]
  d[,w:=as.numeric(PERWT)]
  d[is.na(w)|w<0,w:=0]
  d[,age_n:=as.numeric(AGE)]
  emp_lab<-as.character(haven::as_factor(d$EMPSTAT,levels="labels"))
  d[,employed:=age_n>=16 & age_n<=64 &
       grepl("employed",emp_lab,ignore.case=TRUE) &
       !grepl("unemployed",emp_lab,ignore.case=TRUE)]
  d[,young:=age_n>=20 & age_n<=29]
  cw<-as.character(haven::as_factor(d$CLASSWKR,levels="labels"))
  d[,selfemp:=grepl("self.?employ",cw,ignore.case=TRUE)]
  d[,wage:=clean_num(INCWAGE)]
  d[,hours:=clean_num(UHRSWORK)]
  d[,PUMA_VINTAGE:=puma_vintage(YEAR)]

  z<-d[
    employed & !is.na(PUMA_VINTAGE) & !is.na(PUMA) & PUMA>0 &
      !is.na(OCC2010) & OCC2010>0,
    .(
      n_workers=.N,
      worker_weight=sum(w,na.rm=TRUE),
      young_weight=sum(w[young],na.rm=TRUE),
      selfemp_weight=sum(w[selfemp],na.rm=TRUE),
      wage_sum_w=sum(w*wage,na.rm=TRUE),
      wage_weight=sum(w[!is.na(wage)],na.rm=TRUE),
      hours_sum_w=sum(w*hours,na.rm=TRUE),
      hours_weight=sum(w[!is.na(hours)],na.rm=TRUE)
    ),
    by=.(YEAR,PUMA_VINTAGE,STATEFIP,PUMA,OCC2010)
  ]
  append_dt(z,"puma_occ_parts.csv")

  den<-d[
    age_n>=16 & age_n<=64 & !is.na(PUMA_VINTAGE) & !is.na(PUMA) & PUMA>0,
    .(
      working_age_weight=sum(w,na.rm=TRUE),
      employed_weight=sum(w[employed],na.rm=TRUE),
      n_persons=.N
    ),
    by=.(YEAR,PUMA_VINTAGE,STATEFIP,PUMA)
  ]
  append_dt(den,"puma_den_parts.csv")
  if(chunks%%10L==0L) message("PUMA chunks: ",chunks,"; rows: ",format(rows,big.mark=","))
  invisible(NULL)
})

read_ipums_micro_chunked(
  ddi=ddi,callback=cb,chunk_size=500000,vars=need,
  data_file=data_file,verbose=TRUE,var_attrs=c("val_labels")
)

aggregate_parts<-function(path,keys){
  d<-fread(path)
  metrics<-setdiff(names(d),keys)
  d[,lapply(.SD,sum,na.rm=TRUE),by=keys,.SDcols=metrics]
}
occ<-aggregate_parts(file.path(tmp,"puma_occ_parts.csv"),
  c("YEAR","PUMA_VINTAGE","STATEFIP","PUMA","OCC2010"))
den<-aggregate_parts(file.path(tmp,"puma_den_parts.csv"),
  c("YEAR","PUMA_VINTAGE","STATEFIP","PUMA"))

occ[,young_20_29_share:=fifelse(worker_weight>0,young_weight/worker_weight,NA_real_)]
occ[,selfemployment_share:=fifelse(worker_weight>0,selfemp_weight/worker_weight,NA_real_)]
occ[,mean_nominal_wage:=fifelse(wage_weight>0,wage_sum_w/wage_weight,NA_real_)]
occ[,mean_weekly_hours:=fifelse(hours_weight>0,hours_sum_w/hours_weight,NA_real_)]

setorder(occ,YEAR,STATEFIP,PUMA,OCC2010)
setorder(den,YEAR,STATEFIP,PUMA)
fwrite(occ,file.path(outdir,"puma_occupation_year.csv"))
fwrite(den,file.path(outdir,"puma_year_denominators.csv"))

qa<-list(
  rows_processed=rows,
  chunks_processed=chunks,
  years=sort(unique(occ$YEAR)),
  puma_vintages=sort(unique(occ$PUMA_VINTAGE)),
  occupation_cells=nrow(occ),
  puma_year_cells=nrow(den),
  definition_rule=list(
    "1990"="1990",
    "2000-2011"="2000",
    "2012-2021"="2010",
    "2022+"="2020"
  ),
  primary_broadband_harmonization_target="2010 PUMA",
  treatment_effects_estimated=FALSE
)
write_json(qa,file.path(outdir,"qa.json"),pretty=TRUE,auto_unbox=TRUE)
unlink(tmp,recursive=TRUE)
message("PUMA panel complete.")
