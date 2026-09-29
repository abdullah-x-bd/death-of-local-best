# Randomized Marketplace Experiment

## Research question

What happens to the earnings distribution and occupational participation of human producers when market boundaries are removed and when a scalable AI outside option becomes available?

## Core design

A cluster-randomized repeated-market experiment.

The market is the unit of randomization.

Participants are assigned to fixed roles:
- producers
- buyers

Producer skill is measured before treatment using blinded ratings on pre-treatment tasks.

## Factorial treatments

Primary factorial design:

1. Market integration
   - segmented market
   - integrated market

2. Capacity
   - capacity constrained
   - scalable output

3. AI outside option
   - absent
   - present

This is a 2 × 2 × 2 design.

### Segmented market

Example:
- 10 independent submarkets
- each submarket contains 10 producers and 50 buyers

A buyer can purchase only from producers in the assigned submarket.

### Integrated market

The same total number of producers and buyers are pooled:
- 100 producers
- 500 buyers

The buyer-to-seller ratio is therefore identical.

This is essential. Integration changes the size of the competitor and choice set without mechanically changing aggregate demand per seller.

### Capacity-constrained condition

Each producer can satisfy at most K purchases per round.

This prevents a top producer from serving the whole market.

### Scalable condition

The same output can be purchased by an unlimited number of buyers.

This mimics digital goods and digitally reproducible professional output.

### AI outside-option condition

Buyers are shown a standardized AI-generated option generated before the market opens.

The AI option:
- is identical across randomized markets within a task block
- has a prespecified fixed price
- is clearly labeled
- is not personalized to individual buyers

The AI output is generated before randomization and archived to prevent researcher degrees of freedom.

## Tasks

Use at least three task families so the result is not specific to one kind of work.

Candidate families:
- professional writing
- marketing/creative copy
- analytical explanation based on a short table or chart

Task blocks are randomized and included as fixed effects.

Image generation can be added as a later replication, not as the first confirmatory study.

## Pre-treatment skill measurement

Before any market treatment:
1. every producer completes independent benchmark tasks
2. outputs are rated blind to identity and treatment
3. at least three independent raters score each output
4. the skill index is frozen before treatment outcomes are opened
5. producers are assigned to pre-treatment skill quintiles

The central group is the middle 60 percent, not merely the bottom tail.

## Market rounds

Round 0:
- benchmark skill measurement

Rounds 1-4:
- fixed-price purchasing
- identifies pure demand allocation

Rounds 5-8:
- producers may set prices within prespecified bounds
- estimates price competition and revenue effects

Round 9:
- producers are offered a real costly choice whether to remain in the market
- this creates an experimentally meaningful entry/exit outcome

Optional Round 10:
- previously inactive participants may pay a small participation cost to enter
- tests whether market integration changes occupational entry incentives

## Primary outcomes

One primary outcome from each conceptual family.

### Distribution
MiddleSkillRevenueShare

Revenue earned by producers in pre-treatment skill quintiles 2-4 divided by total human-producer revenue.

### Concentration
Top10RevenueShare

Revenue share of the top 10 percent of producers.

### Participation
MiddleSkillContinuation

Probability that a middle-skill producer pays the real continuation cost and remains active.

### Welfare
BuyerQualityAdjustedSurplus

Prespecified quality-adjusted buyer payoff.

## Secondary outcomes

- Gini coefficient of producer revenue
- number of producers receiving any revenue
- zero-revenue rate
- revenue by pre-treatment skill decile
- consumer concentration across sellers
- prices
- producer effort
- buyer satisfaction
- AI purchase share
- human-versus-AI substitution by producer skill

## Confirmatory hypotheses

H1. Integration lowers MiddleSkillRevenueShare when output is scalable.

H2. The negative integration effect on MiddleSkillRevenueShare is smaller under capacity constraints.

H3. Integration raises Top10RevenueShare under scalable output.

H4. Integration lowers MiddleSkillContinuation under scalable output.

H5. Adding an AI outside option lowers human-producer revenue, with the largest proportional effect on producers whose pre-treatment quality is close to the AI quality level.

H6. AI entry reduces the private return to pre-treatment skill over the portion of the skill distribution whose output is substitutable with the AI option.

## Main regression

For producer i in market m and round r:

Y_imr =
  alpha
  + beta1 Integrated_m
  + beta2 Scalable_m
  + beta3 AI_m
  + beta4 Integrated_m × Scalable_m
  + beta5 Integrated_m × AI_m
  + beta6 Scalable_m × AI_m
  + beta7 Integrated_m × Scalable_m × AI_m
  + task-block fixed effects
  + round fixed effects
  + error_imr

Standard errors clustered at the randomized market level.

For skill-distribution outcomes, add interactions with frozen pre-treatment skill bins.

## Randomization

- randomize at market level
- stratify by task family
- stratify on the mean and variance of producer pre-treatment skill
- randomization seed committed to the repository before treatment assignment

## Sample size

Do not choose the confirmatory N from observed treatment effects.

Stage 0 pilot:
- used only to estimate nuisance parameters such as outcome variance, market-level ICC, attrition, and the distribution of buyer choices
- pilot markets excluded from the confirmatory sample

Confirmatory N:
- fixed by simulation before confirmatory data collection
- minimum 95 percent power for the smallest primary interaction deemed scientifically meaningful
- family-wise alpha controlled across the four primary outcomes

The power simulation code will be versioned and frozen before recruitment.

## Exclusion rules

Pre-register only objective exclusions:
- failed identity/attention checks
- technical failure that prevented treatment exposure
- duplicate participant accounts
- missing benchmark task
- markets failing a prespecified minimum buyer participation threshold

No exclusions based on realized treatment outcomes.

## Manipulation checks

- buyers in integrated markets must observe the intended enlarged seller set
- capacity limits must bind in a prespecified fraction of capacity-constrained markets
- AI option must be visible and technically functional in all AI markets
- buyer-to-seller ratio must be identical across integration arms

## Positive controls

- integrated markets must mechanically increase the number of alternatives visible to buyers
- capacity-constrained markets must show lower maximum realized seller volume than scalable markets

Failure of a positive control invalidates the affected treatment contrast.

## Why this design matters

The experiment separates three mechanisms that are usually bundled together in observational data:

- larger choice sets
- scalable supply
- machine outside options

If integration only harms middle-tier producers when supply can scale, that is direct causal evidence for the market-shelter mechanism rather than a generic effect of larger groups or more competition.

## External-validity bridge

The experiment does not prove historical labor-market effects by itself.

Its role is to identify the mechanism cleanly.

The field studies test whether actual broadband and AI shocks produce the same heterogeneity:
- strongest where output is digitally tradable
- strongest where scale is high
- heterogeneous by pre-treatment local comparative advantage
- weak or absent for physically local occupations
