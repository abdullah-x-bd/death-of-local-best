# NTIA treatment reconstruction protocol v0

This protocol is frozen before any treatment-effect regression.

## Canonical sources

1. NTIA / Data.gov BTOP-BIP applications database.
2. NTIA BTOP awarded-project map data.
3. NTIA Round 2 CCI proposed funded service-area list.
4. Round 2 application guidance and review documentation.
5. National Broadband Map / SBI availability data for first-stage validation.

Legacy NTIA hosts may reject cloud clients. When this happens, an Internet Archive capture of the exact canonical URL may be used strictly as a transport fallback. The original URL, archive timestamp and SHA-256 hash must be recorded.

## Critical limitation of the public Round 2 service-area list

NTIA explicitly states that the public list of 69,880 Census tracts or block groups proposed by Round 2 CCI applicants is **not listed according to specific applications**.

Therefore:

- it may be used to verify the universe and geography format;
- it may not be treated as an applicant-level funded/rejected geography file;
- it may not be used by itself to construct treatment.

## Treatment hierarchy

The project will use the strongest design that can be reconstructed without looking at labor-market outcomes.

1. **Near-cutoff application design**, only if application-level merit scores and a credible advancement/funding threshold can be recovered.
2. **Funded versus rejected applicant-area design**, only if rejected application service areas can be linked credibly to applications.
3. **Award exposure design with transparent comparison construction**, only if 1 and 2 cannot be made credible.

Any move down this hierarchy must be documented before treatment-effect estimation.

## Round 2 geography

CCI guidance requires proposed areas to be represented by full Census geography identifiers:

- 11-digit Census tract IDs, or
- 12-digit Census block-group IDs.

Identifiers must remain strings. Leading zeros may never be discarded.

## Overlap rule

Before outcomes are opened, the treatment build must report:

- overlap among funded projects;
- overlap among rejected proposals;
- overlap between funded and rejected areas;
- counties/tracts with mixed exposure;
- whether comparison areas later receive other BTOP/BIP awards.

The main treatment coding rule for mixed areas will be frozen only after these overlap diagnostics are available.

## Outcome firewall

Scripts in the NTIA treatment reconstruction stage may not read:

- IPUMS outcome tables,
- QCEW employment/wage outcomes,
- CBP establishment outcomes,
- Nonemployer outcomes,
- post-treatment occupational concentration results.

The first causal regression remains blocked until `identification_gate.json` reports that treatment geography, scoring/eligibility logic, overlap handling, and pre-treatment occupation exposure have all been frozen.
