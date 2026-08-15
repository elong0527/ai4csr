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

The expected results are in the book chapter.
