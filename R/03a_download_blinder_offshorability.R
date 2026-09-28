# Download a pinned copy of a public Blinder offshorability transcription.
#
# IMPORTANT:
# The upstream package labels these codes as SOC 2010, but inspection shows
# codes such as 15-1021 = Computer Programmers, which correspond to the
# earlier SOC coding used in Blinder's 2007/2009 work rather than the later
# 2010 SOC structure. We therefore rename the field soc2000_code here.
#
# This file contains occupations listed with offshorability scores in the
# source transcription. It should not be treated as a complete SOC universe.
# Unlisted occupations must not be mechanically assigned a value until the
# Blinder appendix and occupation universe are reconciled.

source(file.path("R","00_config.R"))

url <- paste0(
  "https://raw.githubusercontent.com/jwklee/occupationRiskPack/",
  "84f5d6d9181ee230ef9e2c59618adfaf613db102/",
  "inst/extdata/source_blinder_offshorability.csv"
)

dest <- file.path(DIR_RAW, "blinder_offshorability_transcription.csv")
utils::download.file(url, destfile=dest, mode="wb", quiet=FALSE)

x <- utils::read.csv(dest, stringsAsFactors=FALSE)

required <- c("soc2010_code","soc2010_title","offshorability_index")
if (!all(required %in% names(x))) {
  stop("Unexpected upstream Blinder transcription schema")
}

names(x)[names(x)=="soc2010_code"] <- "soc2000_code"
names(x)[names(x)=="soc2010_title"] <- "soc2000_title"

x$soc2000_code <- as.character(x$soc2000_code)
x$offshorability_index <- as.numeric(x$offshorability_index)

# Reproducibility checks against values visible in Blinder's published table.
checks <- data.frame(
  soc2000_code=c("15-1021","43-9021","27-3041","27-3091","27-4021"),
  expected=c(100,100,93,93,25)
)

for (i in seq_len(nrow(checks))) {
  got <- x$offshorability_index[x$soc2000_code==checks$soc2000_code[i]]
  if (length(got)!=1L || !isTRUE(all.equal(got,checks$expected[i]))) {
    stop("Blinder transcription validation failed for ",checks$soc2000_code[i])
  }
}

utils::write.csv(
  x,
  file.path(DIR_INTERMEDIATE,"blinder_offshorability_listed.csv"),
  row.names=FALSE
)

cat("Rows downloaded:",nrow(x),"\n")
cat("Score range:",min(x$offshorability_index),"-",max(x$offshorability_index),"\n")
