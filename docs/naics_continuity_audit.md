# NAICS continuity audit for Study A

## Newspaper employers

Primary CBP industry:

**511110 Newspaper Publishers**

Census 2002 Economic Census comparative tables explicitly map the 2002 and 1997 newspaper-publishing category and report the same 511110 U.S. industry for newspaper publishers.

This supports continuity across the 1997-to-2002 NAICS revision for the core newspaper-employer outcome.

The 2007 NAICS period will be checked against official concordances before pooling, but the 511110 newspaper-publisher code remains the natural core category.

## Independent work

Primary NES industry:

**711510 Independent Artists, Writers, and Performers**

The code exists in 1997 NAICS and remains 711510 in later NAICS vintages.

The industry definition covers independent or freelance producers, artists, writers, performers, and related technical specialists.

Critically for the Craigslist mechanism, Census definitions explicitly include **independent journalists**.

But the category is broader than journalism.

Examples/cross-references make clear that:

- independent journalists belong in 711510
- independent technical writers belong in 711510
- freelance musicians/vocalists are classified separately in 711130
- independent commercial/graphic designers are classified separately in 541430

## Consequence

A Craigslist-induced increase in 711510 would be consistent with local movement toward independent creative/writing work, but cannot be attributed solely to journalists.

A null effect in 711510 is weak evidence against freelance-journalist reallocation because journalism is only one component of the category.

## Planned robustness categories

Subject to continuity verification and multiple-testing discipline, secondary NES categories may include:

- 711510 Independent Artists, Writers, and Performers
- 541430 Graphic Design Services
- 711130 Musical Groups and Artists

Only 711510 has a direct journalism connection to the newspaper mechanism.

The additional categories should not be interpreted as treated outcomes in the Craigslist study unless a mechanism is specified in advance.

## Classification breaks

Before final panel construction:

1. load official 1997-to-2002 NAICS bridge
2. load official 2002-to-2007 bridge
3. verify whether each target 6-digit code is one-to-one across revisions
4. flag years where scope changes even if the numeric code stays constant
5. preserve native NAICS vintage in the analytic data

No code continuity will be assumed from identical numeric labels alone.
