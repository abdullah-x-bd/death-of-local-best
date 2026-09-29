# Frozen O*NET mechanical exposure specification v0

Frozen before any treatment-effect regression is run.

## Purpose

This specification creates a broad-coverage, pre-treatment O*NET proxy layer. It does **not** claim to measure all five theoretical market-shelter dimensions. In particular, O*NET 4.0 does not contain a clean occupation-wide measure of scalability.

The full five-dimension construct remains reserved for the independent coding study / historical DOT extension.

## Primary source

O*NET 4.0, June 2002, the final analyst database.

O*NET 5.0 is used only as a robustness/transition check using the same item rules.

## Frozen component items

All O*NET 4.0 items below were selected from the historical descriptor inventory without examining treatment-effect estimates.

### Computer-mediated work

- `4.A.3.b.1` Interacting With Computers, Importance (`IM`)

This is a proxy for how naturally the occupation can use electronic production/distribution. It is not itself labeled "digital transmissibility."

### Physical-production dependence

Equal-weight mean of standardized Importance (`IM`) values:

- `4.A.3.a.1` Performing General Physical Activities
- `4.A.3.a.2` Handling and Moving Objects
- `4.A.3.a.4` Operating Vehicles, Mechanized Devices, or Equipment

### Relational / public-facing dependence

Equal-weight mean of standardized historical values:

- `4.C.1.a.4` Contact With Others, Context (`CX`)
- `4.C.1.b.1.f` Deal With External Customers, Context (`CX`)
- `4.A.4.a.8` Performing for or Working Directly with the Public, Importance (`IM`)
- `4.A.4.a.5` Assisting and Caring for Others, Importance (`IM`)

### Secondary mechanical indices

`remote_feasibility_proxy = z(computer_mediated) - z(physical_dependence)`

`partial_market_shelter_proxy = z(physical_dependence) + z(relational_public) - z(computer_mediated)`

The partial shelter proxy is explicitly secondary because scalability and a direct measure of digital deliverability are absent.

No coefficient, p-value, post-treatment concentration measure, wage result, or employment result may be used to add, remove, or reweight these items.

## Scaling

For each O*NET release:

1. retain only the specified scale for each item;
2. standardize each raw item across occupations within that historical release;
3. form equal-weight component means;
4. re-standardize each component across O*NET occupations;
5. require every component item to be observed for a component score.

No post-treatment employment weights are used.

## Frozen occupation crosswalk

Primary chain:

`O*NET-SOC 2000 -> 2000 SOC -> 2010 SOC -> 2010 Census occupation (OCC2010)`

Rules:

1. O*NET-SOC extensions are collapsed to their six-digit 2000 SOC parent.
2. If multiple observed O*NET data-level occupations share a 2000 SOC parent, their scores are averaged equally.
3. The official BLS 2000-to-2010 SOC crosswalk is used.
4. If one 2000 SOC splits into multiple 2010 SOCs, its historical score is copied to each descendant.
5. If multiple 2000 SOCs merge into one 2010 SOC, available historical scores are averaged equally.
6. The official BLS/Census 2010 Census-occupation-to-SOC crosswalk is used.
7. When a Census occupation maps to multiple 2010 SOCs, available SOC scores are averaged equally.
8. When the Census crosswalk uses a broad SOC code ending in zero(s), all available detailed 2010 SOC descendants under that prefix are averaged equally.
9. Every final Census occupation receives source-count and ambiguity diagnostics.
10. No matching rule may use the observed post-treatment outcomes.

## Primary use

The separate component scores are the primary exposure variables.

The secondary partial-shelter index is reported only after the component results.

This file freezes the mechanical O*NET specification before treatment-effect estimation.
