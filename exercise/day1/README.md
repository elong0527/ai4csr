# Day 1 onboarding exercise

Teaching material for the chapter
[A minimal AI agent](https://ai4csr.org/intro-ai-agent.html).
Nothing here is real study data.

## Setup

The KEYNOTE-189 protocol is not stored in this repository. Download it into
this folder:

```sh
curl -O https://cdn.clinicaltrials.gov/large-docs/80/NCT02578680/Prot_SAP_001.pdf
```

Source: MK-3475-189-12, 31-May-2022, trial record
[NCT02578680](https://clinicaltrials.gov/study/NCT02578680).
PDFs in this folder are gitignored.

## The dataset

`kn189-synthetic-adsl.csv` has 28 synthetic subjects. Columns: `STUDYID`,
`USUBJID`, `TRT01A`, `AGE`, `AGEU`, `ENRLFL`, `ITTFL`.

Three issues are planted on purpose:

| Issue | Subjects | Basis in the protocol |
|---|---|---|
| Age below the minimum of 18 | `KN189-103-025` (age 17) | Inclusion criterion 6 |
| Enrolled but not randomized, so outside ITT | `-026`, `-027`, `-028` | ITT is "all randomized subjects" |
| Missing `AGE` | `-024` (in ITT), `-027` (not in ITT) | n/a |

The subject aged 17 is flagged `ITTFL = "Y"` on purpose. The protocol puts every
randomized subject in ITT regardless of eligibility violations, so that subject
belongs in the analysis and in an escalation. Dropping them quietly is the
mistake this exercise is built to catch.

Expected results are in the chapter.
