# Public Data Bootstrap

Large public raw archives are attached to the repository as GitHub Release assets rather than committed as ordinary Git blobs.

This is deliberate because GitHub rejects ordinary files larger than 100 MB and several core sources are hundreds of megabytes or larger.

## Core automated sources

The downloader currently freezes:

- O*NET 4.0 and 5.0
- OEWS metropolitan/nonmetropolitan files, 1997-2025
- County Business Patterns county files, 1986-2023
- Nonemployer Statistics county files, 1997-2023
- NTIA BIP/BTOP applications and project map
- NTIA June 2010 national broadband snapshot
- Ofcom 2023 postcode/output-area coverage
- Ofcom 2025 fixed broadband coverage

QCEW support is implemented in the downloader but is kept out of the first automatic release because the complete 1990-2025 bundle is much larger. It can be frozen separately by decade.

## Run locally

```bash
python -m pip install requests beautifulsoup4
python scripts/fetch_public_data.py \
  --sources onet oews cbp nonemployer ntia ofcom
```

Each file is hashed with SHA-256.

## Very large sources

### Brazil RAIS

RAIS is distributed through the Brazilian Ministry of Labour FTP server and can be multi-gigabyte. Use:

```bash
scripts/fetch_rais.sh 2010 2015 2020 2024
```

The first step freezes the server listing for the requested vintages. We then select the worker and establishment files needed by the preregistered analysis and hash them.

### India PLFS

The MoSPI catalogue is public use, but the present NADA download workflow is session-sensitive. The official catalogue and study metadata are frozen in the source manifest. Exact raw-file endpoints will be added after the portal download transaction is validated.

### BDUK

Premises-level releases are revised every four months and split across hundreds of local-authority files. We freeze the exact release only after the UK causal window is fixed, rather than silently replacing it with "latest" data.

## Confirmatory-data rule

Once a vintage is used in a preregistered analysis, its checksum becomes immutable for that analysis.
