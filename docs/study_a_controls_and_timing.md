# Study A comparison industries and treatment timing

## 1. Primary employer comparison set

The primary CBP publishing panel will contain exactly three 6-digit industries:

- 511110 Newspaper Publishers, treated industry
- 511120 Periodical Publishers, primary comparison
- 511130 Book Publishers, primary comparison

Reason for this restricted comparison set:

- all three are publishing industries
- all involve editorial/content-production activity
- periodical publishers also sell advertising, but Craigslist is not a direct substitute for their core product in the same way as newspaper classifieds
- book publishers provide a second publishing comparison whose business model is not based on local classified advertising

This set is selected before examining extension outcomes.

## 2. Robustness publishing universe

A broader publishing-industry robustness panel may additionally include:

- 511140 Directory and Mailing List / Database and Directory Publishers
- 511191 Greeting Card Publishers
- 511199 All Other Publishers

These are not primary controls because some have very different business models and directory publishing was itself directly exposed to digitization.

Software publishing is excluded from the primary and broad publishing controls because its technology and labor-market trajectory is fundamentally different.

## 3. Internet-only publishers

Exclusive Internet publishing is classified outside 511110/511120/511130 during the study period:

- 516110 under 2002 NAICS
- 519130 under 2007 NAICS

A Craigslist effect that coincides with movement from conventional newspaper publishing toward Internet-only publishing could otherwise look like pure exit from the publishing sector.

Therefore Internet-only publishing will be examined as a secondary offset/reclassification outcome, with the 2002-to-2007 NAICS bridge handled explicitly.

It is not a primary control.

## 4. Balanced industry panel

For the selected industry set, construct a complete county × industry × year grid.

For the pre-2017 study period, Census documents that establishment counts were published even when employment/payroll were withheld.

Accordingly, absence of a selected industry row after schema validation can be coded as zero establishments only after confirming that the source county file contains the county and the target industry is within CBP coverage.

The parser will never convert an existing suppressed employment zero into true zero employment.

## 5. Primary treatment timing

The primary annual treatment indicator is:

PostCL_ct = 1 if Craigslist entered county c on or before December 31 of year t-1.

Interpretation:

Year t is treated only when Craigslist was already present before the reference year began.

Reason:

- CBP employment is measured during the week of March 12
- establishment counts represent locations with paid employees at any time during the year
- annual payroll spans the full year
- using the prior-year cutoff avoids classifying a March observation as treated by an October launch
- it gives every treated reference year a meaningful exposure window

This conservative coding may attenuate effects for launches early in year t, but avoids post-treatment timing ambiguity.

## 6. Secondary timing definitions

Prespecified sensitivity:

### Employment-date treatment

For mid-March employment, PostCL_March_ct = 1 if Craigslist entered by March 1 of year t.

### Fractional annual exposure

For annual-payroll exploratory analysis:

ExposureShare_ct = fraction of days in year t after local Craigslist entry.

This is secondary because annual payroll also responds with organizational lags.

### Published-study timing

Replicate the original paper's exact treatment coding as a validation specification once the public replication code is parsed.

None of these definitions will replace the primary lagged treatment merely because it produces a larger coefficient.

## 7. Main linear employer specification

For selected publishing industries:

Y_cit =
  beta (PostCL_ct × Newspaper_i)
  + FE_(c×i)
  + FE_(c×t)
  + FE_(i×t)
  + error_cit

where:

- c is county
- i is publishing industry
- t is year
- Newspaper_i = 1 for 511110

County × year fixed effects absorb all observed and unobserved local shocks common to the three publishing industries in the same year.

Industry × year fixed effects absorb national newspaper, periodical, and book-publishing trends.

County × industry fixed effects absorb persistent local publishing specialization.

## 8. Remaining identifying assumption

The main remaining threat is a county-specific shock that:

1. occurs at the same time as Craigslist entry, and
2. affects newspaper publishing differently from periodical/book publishing for reasons unrelated to Craigslist.

We address this through:

- event-time leads
- placebo treatment dates
- broader publishing controls
- baseline classified-reliance heterogeneity if recoverable from the replication package
- comparison with the published newspaper first stage
- leave-one-market-out analysis
- local internet/population controls only where they are not absorbed or post-treatment

The fixed-effects structure does not make this assumption disappear.

## 9. Count outcome estimators

Primary inferential object remains a transparent linear fixed-effects specification in establishment levels.

Poisson pseudo-maximum-likelihood with the same conceptual fixed effects may be reported as a count-data robustness model.

We will not select between linear and PPML based on statistical significance.

## 10. Average-market versus average-establishment estimand

Primary:
unweighted county-industry observations, which targets the average included local market.

Robustness:
baseline county population weights and baseline newspaper-establishment weights.

These estimate different objects and will be interpreted separately.
