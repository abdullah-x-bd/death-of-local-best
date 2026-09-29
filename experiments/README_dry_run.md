# Executable marketplace experiment implementation

This directory now contains an executable synthetic dry run for the 2 × 2 × 2 randomized-market design.

The dry run is an engineering and statistical-plumbing test. It is not a pilot and it is not evidence.

## What is validated

- exactly balanced factorial assignment within synthetic blocks;
- fixed participant counts in both segmented and integrated arms;
- identical buyer-to-producer ratio;
- segmented choice sets of 10 producers versus integrated choice sets of 100;
- capacity enforcement;
- standardized AI outside-option availability;
- blind pre-treatment benchmark scoring and skill quintiles;
- fixed-price and producer-price rounds;
- continuation outcome construction;
- all four prespecified primary outcomes.

## What remains deliberately unfrozen

- confirmatory randomization seed;
- confirmatory number of markets;
- pilot nuisance parameters;
- scientifically meaningful minimum effect;
- capacity K;
- actual monetary prices and budgets;
- continuation cost;
- recruitment source;
- benchmark/rating interface;
- task materials and archived AI outputs.

Those are frozen only after the Stage 0 pilot and before confirmatory recruitment.

Synthetic treatment effects from this code must never be reported as empirical findings.
