# Module B design memo: scalable output and local intermediaries

## 1. Motivation

The original theory contains a mechanism that Blinder-style offshorability does not capture.

A musician may need to perform locally, yet recorded music allows a small number of performers to serve huge audiences.

A newspaper journalist may work locally, yet digital platforms can destroy the advertising revenue that finances the local newsroom.

A photographer may be difficult to offshore for a wedding, yet stock photography can be globally replicated.

Module B therefore studies scalability and platform competition separately from remote labor tradability.

## 2. Leading candidate: Craigslist and local newspapers

Djourelova, Durante, and Martin exploit staggered Craigslist entry across U.S. counties between 1995 and 2009.

Their treatment design also uses pre-existing newspaper reliance on classified advertising.

They find declines in newsroom and management staffing among more exposed newspapers.

This establishes a strong intermediary-level causal effect.

## 3. Our candidate extension

The new question would be:

What happens to the local supply of journalistic/writing competence after the intermediary that financed it is hit by digital-platform competition?

Potential outcomes at county/PUMA/metro level:

- resident journalists/reporters/editors
- employment in journalism-related occupations
- self-employment
- earnings
- migration
- occupation switching
- employment outside newspaper publishing
- occupational entry among young workers

## 4. Why this adds information

A fall in newsroom staffing has several possible worker-level consequences:

A. occupational destruction:
workers leave journalism entirely.

B. institutional reallocation:
workers remain journalists but move to digital publishers, nonprofits, government, or firms.

C. self-employment:
workers become freelancers or independent creators.

D. geographic reallocation:
workers move to larger media centers.

E. entry deterrence:
fewer young workers enter the occupation.

These mechanisms are economically distinct.

The national BLS pilot series already motivates this distinction because legacy publishing employment collapses while independent artists/writers/performers do not.

## 5. Identification target

If Craigslist entry timing and baseline newspaper classified reliance can be obtained from the public replication files, the first worker-level specification could mirror the newspaper design while aggregating outcomes to a consistent local geography.

A generic representation is:

Y_at = beta(CL_at × ClassifiedReliance_a,0)
       + area FE
       + year FE
       + other prespecified fixed effects
       + error_at

But this exact equation is not frozen.

Treatment may exist at county/newspaper level while worker outcomes may be observed at PUMA or metro level. Geographic aggregation rules must be set before estimation.

## 6. Major risks

### Geographic mismatch

Craigslist entry is city/county based while public worker microdata may identify PUMAs.

### Small occupational cells

Journalists and editors are relatively rare occupations.

### Industry versus occupation

A journalist may work outside newspaper publishing. This is a feature for our reallocation question but requires careful interpretation.

### Simultaneous internet shocks

Craigslist entry can coincide with broader local internet adoption. The original paper's exposure-by-classified-reliance structure helps distinguish the classified-ad mechanism, but worker-level extension must preserve that logic.

### General equilibrium

Workers may migrate across treated and untreated areas.

## 7. Data feasibility threshold

Module B moves from design memo to confirmatory analysis only if:

- treatment timing is reproducibly available
- baseline classified reliance is reproducibly available
- local worker outcomes can be mapped without excessive geographic ambiguity
- pre-treatment support is adequate
- occupation cell reliability is acceptable

Otherwise it remains a mechanism case study anchored in the existing causal paper.
