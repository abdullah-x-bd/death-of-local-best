# Download the Dingel-Neiman occupation-level work-from-home classification.
#
# This is a robustness/validation construct, not automatically the primary
# measure of digital tradability. Teleworkability and market tradability are
# conceptually distinct.

source(file.path("R","00_config.R"))

url <- paste0(
  "https://raw.githubusercontent.com/jdingel/DingelNeiman-workathome/",
  "3ebab4f646ed45b01162ecd7794f00a518932c53/",
  "occ_onet_scores/output/occupations_workathome.csv"
)

dest <- file.path(DIR_RAW,"dingel_neiman_teleworkable.csv")
utils::download.file(url,destfile=dest,mode="wb",quiet=FALSE)

x <- utils::read.csv(dest,stringsAsFactors=FALSE)

required <- c("onetsoccode","title","teleworkable")
if (!all(required %in% names(x))) {
  stop("Unexpected Dingel-Neiman schema")
}

x$onetsoccode <- as.character(x$onetsoccode)
x$teleworkable <- as.integer(x$teleworkable)

if (!all(x$teleworkable %in% c(0L,1L))) {
  stop("Teleworkable field is not binary")
}

utils::write.csv(
  x,
  file.path(DIR_INTERMEDIATE,"dingel_neiman_teleworkable.csv"),
  row.names=FALSE
)

cat("Rows downloaded:",nrow(x),"\n")
cat("Teleworkable share of occupation rows:",mean(x$teleworkable),"\n")
