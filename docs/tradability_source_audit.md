# Digital tradability measure audit

## Objective

Measure the extent to which an occupation's core work can be supplied across geographic distance.

This is not identical to computer use, remote-work feasibility, routineness, or AI exposure.

## 1. Blinder occupation offshorability

Blinder (2007/2009) ranks more than 800 U.S. occupations by how readily the work can be performed offshore, physically or electronically.

Conceptual fit: high.

Reason: the construct directly concerns whether distance ceases to protect a job from outside competition.

Advantages:

- designed before the labor outcomes we will study at the end of the sample
- occupation-level
- directly connected to remote supply of work
- historically aligned with early broadband diffusion

Limitations:

- partly judgment-based
- may embed the technology frontier of its construction period
- exact raw occupation-level score acquisition and crosswalk quality still need verification
- offshorability includes organizational and international dimensions beyond digital transmission alone

Potential role: strong candidate for primary or co-primary external measure if the original SOC-level scores can be acquired reproducibly.

## 2. Blinder and Krueger survey measure

Blinder and Krueger define offshorability as the ability to perform work duties from abroad and develop several survey/coder measures.

Conceptual fit: high.

Advantages:

- job-level survey foundation
- multiple measurement approaches
- professional-coder measure provides external judgment rather than outcome-based construction

Limitations:

- survey sample rather than direct classification of the full occupation universe
- occupation aggregation and mapping need careful reconstruction
- published in 2013, though based on earlier measurement work

Potential role: validation and potentially primary measure if the occupation-level mapping can be recovered cleanly.

## 3. Dingel and Neiman work-from-home classification

Dingel and Neiman classify whether occupations can be performed entirely at home using O*NET job characteristics.

Their public replication repository contains an occupation-level file with O*NET SOC code, occupation title, and a teleworkable indicator.

Conceptual fit: medium.

Advantages:

- fully reproducible
- transparent code
- full occupation coverage
- straightforward crosswalks
- external measure not constructed from our outcomes

Limitations:

- measures feasibility of home production, not whether output is sold into a geographically distant market
- constructed in 2020, after much of the Wave 1 treatment period
- some occupations can be performed remotely without being exposed to broad external product-market competition
- some tradable outputs can involve workplace presence even if the final output is digitally transmitted

Potential role: secondary validation measure, not automatically the primary treatment moderator.

Source repository:
https://github.com/jdingel/DingelNeiman-workathome

Verified output:
occ_onet_scores/output/occupations_workathome.csv

## 4. Jensen and Kletzer / Gervais and Jensen

Jensen and Kletzer develop tradability/offshorability measures for services and discuss characteristics such as internet enablement, information intensity, and absence of face-to-face contact.

Gervais and Jensen estimate industry-level trade costs and classify tradable service industries.

Conceptual fit: high for product/service tradability, but the unit is often industry rather than occupation.

Potential use:

- external validation
- industry-level replication
- construction guidance
- mechanism heterogeneity by industry tradability

## 5. Construct separation

The project will not silently treat the following as synonyms:

Digital tradability:
Can the core service or output be supplied across distance?

Teleworkability:
Can the worker perform the job away from the employer's workplace?

Offshorability:
Can the work be performed from another country for the same or equivalent customers/employer?

Routine task intensity:
How routine is the job's task content?

AI exposure:
How strongly do current AI capabilities overlap with occupational tasks?

These constructs may correlate, but they represent different mechanisms.

## 6. Provisional measurement hierarchy

Before outcome regressions, attempt to obtain:

1. historical occupation-level Blinder offshorability scores
2. Blinder-Krueger coder-based measure or mapped occupation-level derivative
3. Dingel-Neiman teleworkability score as external robustness
4. industry-level tradability from Gervais-Jensen as a separate validation exercise

If historical offshorability scores cannot be reconstructed transparently, build a predetermined O*NET-based digital-tradability index with a scoring rule frozen before examining outcomes.

## 7. Decision rule

The primary measure will be selected for conceptual validity and reproducibility, not because it yields the largest or most significant coefficient.

All serious alternative measures identified before estimation will be reported as robustness checks, including null or contradictory results.
