#!/usr/bin/env bash
set -euo pipefail
ROOT="\${RAIS_ROOT:-data/raw_public/rais}"
mkdir -p "$ROOT"
if [ "$#" -eq 0 ]; then
  echo "Pass one or more years, for example: $0 2010 2015 2020 2024" >&2
  exit 2
fi
command -v lftp >/dev/null || { echo "lftp is required" >&2; exit 2; }
for year in "$@"; do
  mkdir -p "$ROOT/$year"
  echo "Freezing public RAIS FTP listing for $year"
  lftp -e "
    set ftp:ssl-allow no;
    set net:max-retries 3;
    open ftp://ftp.mtps.gov.br;
    cd /pdet/microdados/;
    find .;
    bye
  " | grep -i "$year" > "$ROOT/$year/listing.txt" || true
  echo "Saved $ROOT/$year/listing.txt"
done
