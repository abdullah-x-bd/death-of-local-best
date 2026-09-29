# Identification Strategy

## Why one design is not enough

The target mechanism contains both market-level spillovers and equilibrium responses. A single difference-in-differences estimate cannot establish the full chain.

The identification strategy therefore uses three layers:

1. randomized mechanism identification
2. quasi-experimental real-world shocks
3. cross-setting replication and negative controls

The first layer identifies the mechanism.
The second identifies whether real technological shocks move outcomes in the predicted direction.
The third attacks alternative explanations and external-validity concerns.

## Causal estimand 1: effect of market integration

Defined in the randomized marketplace experiment as:

ATE_integration = E[Y | integrated] - E[Y | segmented]

while preserving:
- buyer-to-seller ratio
- aggregate buyer budget
- producer skill distribution
- task mix

This is the cleanest causal estimate in the project.

## Causal estimand 2: scalability interaction

The theory is not merely "more competitors hurt producers."

The mechanism requires that superior producers can absorb more demand when scale constraints are weak.

Primary interaction:

DID_scale =
  (Integrated - Segmented)_scalable
  -
  (Integrated - Segmented)_capacity-constrained

A negative value for middle-tier revenue share is direct evidence that scalability amplifies the consequences of market integration.

## Causal estimand 3: AI outside option

Random assignment of an AI option identifies:

ATE_AI = E[Y | AI option] - E[Y | human only]

The key heterogeneity is by frozen pre-treatment human skill and by task family.

This gives a causal test of whether machine-produced competence changes the private return to intermediate human skill.

## Field identification: broadband

### Problem

Broadband placement is endogenous.
Places receiving early broadband differ from places receiving it later.

### Preferred solution

Use broadband programs where treatment can be compared with credible applicants that were not funded.

Primary candidate:
BIP/BTOP under the 2009 Recovery Act.

A 2026 study reconstructs rejected applicant counties, demonstrating that this comparison set is recoverable.

If application scores or a funding threshold can be reconstructed, near-cutoff applicants become the preferred design.

### Triple-difference logic

The causal object is not the average local effect of broadband.

Broadband can help a place export as well as expose it to imports.

The theory predicts heterogeneity by:
- occupation tradability/scalability
- pre-treatment local comparative advantage

Specification:

Y_got =
  alpha_go
  + gamma_gt
  + delta_ot
  + beta [Broadband_gt × Tradability_o × PreAdvantage_go]
  + epsilon_got

Interpretation:
beta tests whether broadband reallocates activity in tradable occupations toward places that already possessed comparative advantage.

### Why the fixed effects are demanding

alpha_go:
absorbs all permanent place-occupation specialization.

gamma_gt:
absorbs every local shock common to occupations in a given year.

delta_ot:
absorbs every national occupation-specific shock in a given year.

Identification therefore comes from differential movement of occupations within the same treated place relative to the national movement of those occupations.

## Interference and SUTVA

Internet integration creates spillovers by construction.

A producer in treated geography A may compete with producers in control geography B.

We will not assume away this interference.

### Strategy

1. The randomized market experiment defines treatment at the complete market level, preventing cross-market interference.

2. Field estimates are interpreted as effects of own-area integration plus equilibrium spillovers, not a pure partial-equilibrium treatment effect.

3. Where data permit, construct competitor-exposure measures:
   CompetitorExposure_got =
   weighted broadband treatment in other geographies × occupation tradability.

4. Report direct and exposure effects separately.

5. Use broader labor-market clusters as a robustness unit to reduce cross-boundary contamination.

## Field identification: platform entry

Craigslist provides staggered geographic platform entry.

Existing work establishes effects on newspaper classified advertising and circulation.

Our extension can estimate:
- local journalism/editorial employment
- photographer employment
- newspaper establishment survival

Modern staggered-adoption estimators must be used rather than naive two-way fixed effects when treatment effects are heterogeneous.

## Field identification: generative AI

### Weak design to avoid

Simple pre/post November 2022 comparisons.

### Baseline design

Continuous treatment intensity based on occupation characteristics fixed before post-2022 outcomes.

Requirements:
- long pre-period
- event-study coefficients
- multiple independent exposure measures
- occupation × time and geography × time controls where feasible
- explicit tests for differential pre-trends

### Stronger design

Obtain actual firm or platform AI adoption dates.

Then estimate staggered adoption using not-yet-treated controls.

Preferred estimand:
effect of actual AI adoption × pre-treatment task substitutability.

### Strongest design

Partner with a labor platform or firm for randomized AI availability.

This would directly connect AI-induced productivity compression to hiring, bidding, wages, and contract allocation.

## Mechanism mediation

We will not use naive mediation regressions to claim complete causal mediation.

Mechanisms are established through randomized interventions on the mechanism itself:

- integration randomized
- capacity/scalability randomized
- AI outside option randomized

The field studies test whether real shocks reproduce the same heterogeneous signatures.

## Required negative controls

### Occupation negative controls
Occupations with:
- mandatory physical presence
- low digital deliverability
- strict one-client-at-a-time capacity

Examples:
- barbers
- dental hygienists
- many construction trades

### Timing placebos
Assign false treatment dates before actual broadband/platform/AI exposure.

### Geography placebos
Use regions outside actual program service areas.

### Outcome placebos
Outcomes that should not respond to the proposed channel over the same horizon.

## Decision standard

A causal claim enters the abstract only if:
- randomization or quasi-experimental assignment supports it
- pre-specified diagnostics pass
- treatment effects have the predicted heterogeneity
- at least one important alternative explanation is directly falsified

Anything weaker remains descriptive or suggestive.
