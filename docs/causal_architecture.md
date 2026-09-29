# Causal Identification Architecture v1.0

## Target claim

The paper does not attempt to establish the vague claim that "technology destroys local jobs."

The target causal claim is narrower and testable:

> When technology removes market shelter, economic activity in scalable occupations shifts toward a smaller set of producers and places, reducing the viability of middle-tier local producers even when aggregate output or national employment does not fall. Generative AI creates a second shock by reducing the scarcity of competent cognitive output itself.

## Causal chain

We separate the full argument into links that must be independently supported.

C1. Market integration increases the effective choice set facing consumers and the effective competitor set facing producers.

C2. When output is scalable, increased market integration reallocates demand toward higher-ranked producers more strongly than when output is capacity constrained.

C3. This reallocation reduces revenue, survival, and entry among middle-ranked producers and can concentrate production geographically even when total demand is unchanged or rises.

C4. Generative AI reduces the amount of human labor needed to produce a given level of competent output and compresses productivity differences among human workers.

C5. When an AI outside option enters a market, human demand and income shift in ways predicted by pre-treatment task exposure and by the market-shelter framework, producing a second erosion of middle-tier opportunity in digitally tradable occupations.

No single design is treated as sufficient for the whole chain.

## Study architecture

### Study 1: Randomized market-integration experiment

Purpose: identify C1-C3 directly under random assignment.

Design: factorial online marketplace experiment randomizing market integration, seller capacity, and availability of an AI outside option.

Key contribution: this is the mechanism experiment. It identifies the causal effect of removing market boundaries while holding buyer-to-seller ratios, total purchasing power, task quality, and the producer skill distribution fixed.

Primary estimands:
- effect of integration on middle-skill producer revenue share
- integration × scalability interaction
- effect on top-decile revenue share and Gini concentration
- effect on seller continuation and costly re-entry
- AI outside-option effect and AI × producer-skill interaction

### Study 2: Broadband quasi-experiment in real local labor markets

Purpose: identify whether increased digital market access changed the geography of occupations in the direction predicted by Study 1.

Preferred treatment source:
- 2009-2010 BIP/BTOP broadband programs, using funded areas compared with rejected applicant areas
- stronger variants if application scoring permits a credible cutoff or near-cutoff design

Core specification:

Y(g,o,t) = alpha(g,o) + gamma(g,t) + delta(o,t)
         + beta [Broadband(g,t) × Tradability(o) × PreLocalAdvantage(g,o)]
         + error(g,o,t)

The geography-year fixed effect absorbs any local shock common to all occupations.
The occupation-year fixed effect absorbs any national shock common to an occupation.
The geography-occupation fixed effect absorbs persistent local specialization.

The identifying variation is therefore within the same place and year, across occupations with different pre-treatment tradability/scalability, compared with the same occupations in untreated places.

Primary prediction:
- broadband exposure should benefit initially advantaged producer clusters and reduce the relative local share of highly tradable/scalable occupations in initially weak local markets
- locally nontradable occupations should not show the same pattern

### Study 3: Institutional channel quasi-experiments

Purpose: establish that digital entry can causally weaken local intermediating institutions.

Anchor design:
- staggered Craigslist entry across U.S. cities and newspaper dependence on classified advertising

This literature already shows causal effects on newspaper advertising rates and circulation. We will not claim novelty for that result. We use it as independent mechanism evidence that digital market entry can drain revenue from locally bounded institutions.

Possible extension:
- link local newspaper exposure to occupation-specific journalist/editor/photographer employment and establishment counts where geography can be matched cleanly.

### Study 4: Generative-AI second shock

Purpose: identify C4-C5.

C4 is established with randomized and staggered-rollout workplace evidence:
- Noy and Zhang, Science 2023
- Brynjolfsson, Li and Raymond, QJE 2025

Our own confirmatory analysis targets C5.

Primary field design:
- occupation × local labor market event study around late 2022
- treatment intensity fixed using pre-treatment task characteristics and multiple independent AI-exposure measures
- never use a post-outcome measure of exposure as the primary treatment
- include occupation × time and geography × time fixed effects where feasible
- require flat differential pre-trends

Preferred higher-quality extension:
- proprietary vacancy data such as Lightcast or Revelio Labs
- platform transaction data from Upwork/Fiverr or a research collaboration
- firm adoption data with staggered AI rollout

## Study 1 as the causal anchor

Observational studies can always face residual confounding. The randomized marketplace experiment is therefore the logical anchor.

The historical studies answer external-validity questions:
- did the mechanism appear in real places?
- did it occur during actual technological transitions?
- did effects differ by the exact dimensions manipulated experimentally?

The paper's causal argument becomes strongest only when the signs and heterogeneity line up across all designs.

## Falsification structure

The theory can fail.

### Falsification F1
If integration does not reduce middle-tier revenue under scalable supply in the randomized experiment, the central market-shelter mechanism is rejected.

### Falsification F2
If integration has the same effect under strict seller capacity constraints, the scalability mechanism is rejected.

### Falsification F3
If broadband treatment produces similar effects in occupations requiring physical local presence, the geographic-market mechanism is weakened.

### Falsification F4
If treated and control geographies show differential pre-trends before broadband expansion, the corresponding field estimate is not treated as causal.

### Falsification F5
If post-2022 effects appear equally in occupations with low and high pre-treatment AI exposure, the second-shock interpretation is weakened.

### Falsification F6
If estimated AI effects begin well before late 2022, we do not attribute the divergence to generative AI.

## Alternative explanations to attack explicitly

1. General local economic decline
   - addressed by geography × year fixed effects.

2. National decline of an occupation
   - addressed by occupation × year fixed effects.

3. Migration rather than disappearance of opportunity
   - measure migration and resident/workplace employment separately where possible.

4. Industry composition
   - add industry controls and perform within-industry analyses where data permit.

5. Skill-biased technical change unrelated to market integration
   - compare digital tradability/scalability with routine-task and education measures.

6. Urban agglomeration trends predating the internet
   - pre-trend event studies, long-run placebo periods, and pre-treatment local advantage interactions.

7. Measurement changes in OEWS
   - harmonize occupation codes and geographies; validate key results in IPUMS microdata.

8. Macroeconomic post-2022 hiring slowdown
   - use occupation × time and geography × time controls, pre-trends, multiple exposure measures, and data on actual AI adoption if obtainable.

## Epistemic standard for the paper

We will use the phrase "causal" only for:
- randomized estimates
- quasi-experimental estimates whose identifying assumptions are explicitly stated and survive prespecified diagnostics

We will not describe descriptive concentration trends as causal.

The full chain is considered supported only if:
1. Study 1 identifies the mechanism under randomization.
2. Study 2 shows field effects with matching heterogeneity.
3. At least one independent institutional shock supports the local-intermediary channel.
4. Study 4 shows a distinct AI-era effect consistent with the second-shock prediction.
5. Main findings replicate under at least two non-equivalent outcome datasets or two countries/settings.

## Publication strategy

The evidentiary target is a broad interdisciplinary paper, not a single-regression economics note.

A high-end submission requires:
- one clean randomized mechanism study
- at least one strong field quasi-experiment
- a transparent preregistration
- outcome-neutral harmonization rules
- negative controls
- replication across outcomes/settings
- public code and data provenance
