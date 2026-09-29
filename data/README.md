# Data directory

Do not commit restricted, licensed, personally identifying, or large raw datasets.

Recommended local structure:

data/raw/
data/interim/
data/processed/
data/external/

Each raw dataset must have an entry in docs/data_provenance.md and a checksum in data/checksums.csv.

Only small public crosswalks, schemas, and synthetic fixtures should be committed.
