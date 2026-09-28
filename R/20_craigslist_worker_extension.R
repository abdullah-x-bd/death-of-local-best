# Craigslist worker-level extension
#
# Intentionally locked until:
# 1. public Craigslist replication treatment data are acquired
# 2. county/newspaper exposure is reconstructed and verified
# 3. county-to-PUMA mapping is frozen
# 4. journalism occupation set is frozen
# 5. primary outcomes and reliability rules are frozen
# 6. published newspaper-level first stage is reproduced
#
# No headline worker regression should be run before these prerequisites.

source(file.path("R","00_config.R"))

prerequisites <- c(
  "Craigslist treatment data acquired and checksummed",
  "baseline classified exposure reproduced",
  "county-to-PUMA mapping frozen",
  "primary journalism occupation set frozen",
  "primary worker outcomes frozen",
  "cell reliability rule frozen",
  "newspaper-level first stage reproduced"
)

cat("Craigslist worker extension remains locked.\n")
cat(paste0(seq_along(prerequisites), ". ", prerequisites, "\n"))

stop("R/20_craigslist_worker_extension.R is locked by the pre-analysis plan.")
