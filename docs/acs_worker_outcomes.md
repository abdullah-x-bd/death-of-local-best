# ACS worker-outcome specification for the Craigslist extension

## Verified early-period occupation codes

The 2002-era Census occupation system used in the mid-2000s contains:

| Census OCCP | Occupation |
|---|---|
| 2810 | News analysts, reporters and correspondents |
| 2830 | Editors |
| 2840 | Technical writers |
| 2850 | Writers and authors |
| 2860 | Miscellaneous media and communication workers |
| 2910 | Photographers |

Related arts/media occupations exist but will not be inserted into the treated set without a mechanism-based reason.

## Primary treated occupation candidate

The cleanest primary occupation is:

**2810 News analysts, reporters and correspondents**

Reason:

Craigslist's identified newspaper revenue shock led to newsroom staffing reductions. Reporters/correspondents are more mechanism-specific than all writers or media workers.

Editors may be a prespecified secondary treated occupation because the published newspaper analysis documents editorial staffing effects.

Writers/authors, photographers, technical writers, and other media occupations should initially be separate secondary outcomes rather than pooled into a broad "creative" treatment group.

## Confirmed PUMS dimensions needed

The early ACS PUMS supports the essential worker-level fields required for the design, including:

- occupation
- person weights
- age
- class of worker
- employment status
- wage/salary income
- self-employment income
- total earnings/income
- usual hours
- industry
- residence PUMA
- place-of-work PUMA / state
- migration variables

Exact variable names and coding will be audited year by year before construction.

## Two geographic outcomes

### Residence measure

Question:

Do people employed in journalism-related occupations cease to reside in the exposed local market?

This incorporates employment changes plus migration/residential sorting.

### Workplace measure

Question:

Do journalism-related jobs cease to be located in the exposed local labor market?

This is closer to the local-job outcome.

The two should not be treated as interchangeable.

## Worker adjustment decomposition

For exposed journalism workers, we want to distinguish:

1. local job loss
2. occupational switching
3. industry switching
4. self-employment/freelancing
5. geographic migration
6. earnings loss
7. foregone entry among younger workers

The first paper version may not identify all six perfectly. The manuscript will only report the margins actually observed.

## Entry outcome

A candidate entry measure is the share or weighted count of workers aged 22-30 in the treated occupation.

This age band remains provisional.

The final range must be frozen before estimation and justified based on typical labor-force entry rather than selected for significance.

## Reliability

Rare occupation × PUMA × year cells can be extremely noisy.

We therefore need an ex ante reliability rule.

Candidate options:

- pool journalism outcomes over multiple related occupation codes only when conceptually justified
- use multi-year windows around treatment
- estimate individual-level models rather than relying solely on cell medians
- minimum unweighted cell threshold for distributional outcomes
- use employment presence only when the sampling-based false-zero problem is quantified

A zero observed journalist count in a PUMA is not automatically evidence that the occupation is truly absent.

## Crucial implication

For Study A, the most defensible primary outcomes may be weighted employment share and workplace employment rather than a raw binary presence indicator, unless simulation shows that ACS sampling can measure occupation absence reliably.

The "death of local niches" presence outcome can remain central in the broader paper, but its measurement error must be quantified before it becomes primary.
