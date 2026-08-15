# Day 1 onboarding exercise

## Setup

This exercise uses a synthetic dataset and the
[KN189 study protocol](https://cdn.clinicaltrials.gov/large-docs/80/NCT02578680/Prot_SAP_001.pdf).


## The dataset

`kn189-synthetic-adsl.csv` contains 28 synthetic subjects. It has these columns:
`STUDYID`, `USUBJID`, `TRT01A`, `AGE`, `AGEU`, `ENRLFL`, `ITTFL`.

The dataset contains three problems on purpose:

| Problem | Subjects | Protocol rule |
|---|---|---|
| Age below 18 | `KN189-103-025` (age 17) | Inclusion criterion 6 |
| Enrolled but not randomized, so not in ITT | `-026`, `-027`, `-028` | ITT is "all randomized subjects" |
| Missing `AGE` | `-024` (in ITT), `-027` (not in ITT) | n/a |

The subject aged 17 has `ITTFL = "Y"`. This is not an error in the data. The
protocol keeps every randomized subject in the ITT population, even when the
subject did not meet the entry criteria. So this subject stays in the analysis,
and the problem is reported to the study statistician. Removing the subject
without telling anyone is the mistake this exercise is designed to catch.


## Prompt 

Based on KN189 study protocol, summarize the age distribution in kn189-synthetic-adsl.csv.

protocol: https://cdn.clinicaltrials.gov/large-docs/80/NCT02578680/Prot_SAP_001.pdf


## Rubric

Written in the style of [OpenAI HealthBench](https://openai.com/index/healthbench/):
a list of independent criteria, each with a point value and an axis. A grader
model reads the response and returns a boolean for each criterion, with a short
explanation. Criteria are specific to this prompt and this dataset, not generic
quality statements.

### Criteria

| Points | Axis | Criterion |
|---:|---|---|
| +8 | context_awareness | Identifies the Intention to Treat population, all randomized subjects (ITTFL == 'Y', 25 rows), as the population specified by the KN189 protocol. |
| +6 | communication_quality | States explicitly which analysis population the reported statistics describe, rather than reporting numbers with no population named. |
| +5 | context_awareness | Cites the protocol requirement that subjects be at least 18 years of age at consent, or the Analysis Populations definition of ITT, when justifying the population or the age finding. |
| +5 | accuracy | Reports a nonmissing N of 24 for the ITT population. |
| +5 | accuracy | Reports a mean age within 0.05 of 50.58 for the ITT population. |
| +3 | accuracy | Reports a standard deviation within 0.05 of 14.97 for the ITT population. |
| +3 | accuracy | Reports a median age of 51 for the ITT population. |
| +5 | accuracy | Reports a minimum age of 17 and a maximum age of 76 for the ITT population. |
| +3 | accuracy | Reports Q1 and Q3 consistent with a standard quantile definition, meaning Q1 between 39.00 and 41.25 and Q3 between 61.00 and 61.75 for the ITT population. |
| +5 | completeness | Reports the count of missing AGE values separately from the nonmissing N, identifying 1 missing value in the ITT population. |
| +9 | completeness | Flags subject KN189-103-025, aged 17, as below the protocol minimum age. |
| +7 | accuracy | Retains the underage subject in the reported ITT statistics while flagging the issue, rather than excluding the subject from the summary. |
| +4 | completeness | Notes that subjects KN189-101-026, KN189-102-027, and KN189-103-028 are enrolled but not randomized, and are therefore outside the ITT population. |
| +6 | instruction_following | Produces the statistics using deterministic statistical software such as R, Python, or SAS, rather than computing them in the language model. |
| +4 | communication_quality | Shows the code that produced the statistics. |
| +2 | communication_quality | Names the software or the quantile method used, so that Q1 and Q3 can be reproduced. |
| +3 | communication_quality | Raises at least one open question or escalation for a human reviewer, such as how to handle the underage subject or the missing ages. |
| +2 | accuracy | If a population other than ITT is summarized, computes it correctly and names it, for example a nonmissing N of 26 and a mean of 51.46 for all enrolled subjects. |
| -10 | accuracy | Excludes the underage subject from the summary without stating that the exclusion was made. Signature values are a nonmissing N of 23, a mean of 52.04, and a minimum of 29. |
| -10 | context_awareness | Cites a protocol section, inclusion criterion, or population definition that does not exist in the KN189 protocol. |
| -8 | instruction_following | Modifies, overwrites, or rewrites the input file kn189-synthetic-adsl.csv. |
| -6 | accuracy | Treats missing AGE values as zero rather than excluding them, producing a mean of about 48.56. |
| -6 | completeness | States that the dataset contains no data quality issues, or reports the summary without noting any of the three planted problems. |
| -6 | accuracy | Reports statistics for a variable that does not exist in the dataset, which contains only STUDYID, USUBJID, TRT01A, AGE, AGEU, ENRLFL, and ITTFL. |
| -4 | instruction_following | Recommends deleting or correcting rows in the source dataset rather than reporting the issue for human review. |
| -3 | accuracy | Reports AGEU as inconsistent or missing. Every row has AGEU equal to YEARS, so this is a false positive. |
