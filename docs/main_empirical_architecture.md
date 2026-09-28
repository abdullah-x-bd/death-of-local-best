# Main empirical architecture

## Decision

The paper will use a two-study first-wave architecture rather than asking one broadband regression to carry every causal claim.

### Study A: high-internal-validity causal anchor

**Digital platform shock to local newspaper finance**

Leading treatment: staggered Craigslist entry across U.S. local markets, interacted with newspapers' pre-entry reliance on classified advertising.

Existing causal result from Djourelova, Durante, and Martin:

- Craigslist entry reduces local classified advertising
- the effect is concentrated among newspapers reliant on classified ads before Craigslist
- exposed newspapers reduce staffing, including newsroom staff

Our extension asks what happens to the *local workers and occupations* after that institutional shock.

Primary worker outcomes under consideration:

- presence of news analysts/reporters/correspondents in the local labor market
- employment share in news occupations
- real earnings
- self-employment
- industry switching
- migration
- entry among young workers

This study is narrow. It is not evidence about every occupation.

Its value is unusually clear treatment logic.

### Study B: broad generalization test

**Broadband expansion × occupation-level remote tradability**

This study asks whether the same general mechanism appears across a broad occupation universe:

> when connectivity expands, do occupations whose services can be supplied from elsewhere lose more local labor-market protection than occupations requiring local physical presence?

Primary moderator candidates:

- Blinder offshorability
- Blinder-Krueger offshorability
- Dingel-Neiman teleworkability as robustness, not synonym

Primary outcomes:

- local occupational presence
- local employment share
- real median earnings

This study has greater external breadth but a harder treatment-identification problem.

It will receive causal language only if broadband treatment variation is credibly exogenous or plausibly exogenous under the prespecified design.

## Why Study A comes first

Raw broadband rollout is jointly determined by population, density, income, technology demand, infrastructure, and local economic conditions.

Craigslist provides a narrower platform shock whose economic channel is much more specific: competition for classified advertising.

The existing paper's design has two layers of identification:

1. staggered local entry
2. ex ante classified-ad reliance

The first stage is directly observed: classified pages fall after Craigslist entry, especially at papers that relied on classifieds.

This gives Study A a much clearer causal chain:

Craigslist entry
-> classified-ad competition
-> newspaper classified volume/revenue shock
-> newspaper staffing cuts
-> worker/local-occupation adjustment

Our extension focuses on the last arrow.

## Worker geography

ACS PUMS provides both residence PUMA and place-of-work PUMA variables in the early period.

This matters because a residence-only analysis can confuse local job loss with residential sorting.

Where harmonization permits, Study A will construct both:

- residence-based occupational outcomes
- workplace-based occupational outcomes

Migration variables will be analyzed separately.

## Journalism occupation set

For the 2002-era Census occupation classification:

- 2810: News analysts, reporters and correspondents
- 2830: Editors
- 2840: Technical writers
- 2850: Writers and authors
- 2860: Miscellaneous media and communication workers
- 2910: Photographers

The *primary journalism occupation definition* is not yet frozen.

A narrow definition centered on 2810 is preferable for mechanism specificity, while broader communication occupations may be secondary outcomes.

We will not select the occupation bundle based on which produces a significant result.

## Negative controls

Study A needs occupations that should not be directly affected by a newspaper classified-revenue shock.

Controls will be selected using a prespecified rule rather than hand-picked after results.

Candidate approaches:

1. all non-media occupations with occupation×year fixed effects
2. matched occupations on education, baseline wage, and local prevalence
3. selected placebo occupation families with similar education but no newspaper-production role

The final primary control structure must be frozen before worker outcome estimation.

## Study A identifying equation

A provisional worker/local-area specification is:

Y_pot =
  beta * Craigslist_pt * Journalism_o * BaselineClassifiedExposure_p
  + FE_(p×o)
  + FE_(p×t)
  + FE_(o×t)
  + error_pot

where:

- p is a harmonized local geography
- o is occupation
- t is year
- Craigslist is local platform availability
- Journalism identifies the prespecified treated occupation group
- BaselineClassifiedExposure is pre-treatment exposure of local newspapers to classified advertising

This is provisional because the treatment data originate at newspaper/county level while ACS outcomes are observed at PUMA level.

No regression will be estimated until the county-to-PUMA aggregation rule is frozen.

## Required first stage for our extension

Before interpreting worker outcomes, verify in the replication data that the constructed local exposure measure reproduces the known newspaper-level first stage:

Craigslist × baseline classified reliance
-> reduction in classified pages / newspaper staffing.

If our geographic aggregation destroys the published first stage, the worker extension is not credible.

## Study A rejection conditions

The worker-extension hypothesis is weakened or rejected if:

- treated journalism outcomes move before Craigslist entry
- comparable placebo occupations move similarly
- worker results appear without the published intermediary first stage in our harmonized geography
- results depend on one or two large media markets
- workplace outcomes do not move but residence outcomes do, indicating residential sorting rather than local job loss
- occupational declines are fully offset by reclassification into closely related occupations
- the result changes sign under reasonable county-to-PUMA mappings

## Relationship between Studies A and B

Study A asks a narrow question with high internal validity.

Study B asks whether the broader geographic-scarcity mechanism generalizes.

A strong paper does not require both to be positive.

Possible outcomes:

- A positive, B positive: strong evidence for a broader competence-rent mechanism
- A positive, B null: clear institutional/platform mechanism, weak evidence for general broadband effect
- A null, B positive: broad association/causal effect but no support from the newspaper mechanism
- A null, B null: reject the first-wave empirical thesis

The interpretation will follow this matrix rather than assuming convergence.
