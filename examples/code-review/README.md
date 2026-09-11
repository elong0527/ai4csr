# Controlled R code-review fixture

One bounded Biometrics review task for comparing agentic code-review
workflows (Codex, Claude Code, GitHub Copilot) against the same
immutable base/head diff. Base R only.

## Review task

`code/summarize_demog_head.R` is the pull request under review. The
task specification it claims to implement:

- Population: safety population, defined as rows with `SAFFL == "Y"`.
  Percentages and counts use the safety-population N per arm.
- Missing age: excluded from the mean and counted in an `Age_missing`
  row, never silently dropped.
- One row per subject: deduplicate on `USUBJID` before summarizing.
- Supplemental race: attached without changing row counts.
- Treatment labels: taken from the `TRT01P` values in the data.
- Sex: reported as recorded, including `Unknown`.

`code/summarize_demog_base.R` is the reference implementation that
satisfies this specification. The head script contains seeded defects
across distinct categories (population/denominator logic, missing-data
handling, joins/duplicates, treatment labels, sex coding) plus one
compliant formatting change and one behavior-neutral rename that a
review should not flag as defects. The defect inventory and scoring
rules live in a separately maintained answer key so that survey runs
stay blind.

## Run

From this directory (base R only, no paid agents needed):

```sh
Rscript code/summarize_demog_base.R --data=data --out=/tmp/base_summary.csv
Rscript code/summarize_demog_head.R --data=data --out=/tmp/head_summary.csv
Rscript checks/run-fixture-checks.R
```

The checks verify that the base output matches the expected
safety-population values, that the head script runs cleanly while
producing different output, that all code is base R, and that all
subject identifiers are synthetic.

## Coverage inventory and allowed context

In scope for every evaluated agent run:

- `code/summarize_demog_head.R` (the diff under review)
- `code/summarize_demog_base.R` listed for reference only when the
  protocol arm under test permits it; blind arms receive the task
  specification above instead
- `data/adsl.csv`, `data/race_lookup.csv`, and this README

Out of scope for evaluated agents:

- `checks/` (encodes expected values; running it collapses the task)
- the separately maintained answer key and scoring files

Product differences that cannot be equalized (review trigger, latency,
cost accounting) are recorded per run rather than forced into a common
shape; the protocol names them before results are compared.

## What is real and what is constructed

Constructed: the data, the scripts, and every defect. All 24 subjects
are synthetic (`SYNTH-` identifiers); they contain no real participant
records and cannot support any conclusion about a real study. The
demographics task is teaching context for reviewer evaluation.

## Scope of this fixture

This directory delivers the review task, the data, and the
deterministic checks. The scored answer key with an independent owner
and the reader-facing survey chapter are separate deliverables that
reference this fixture by its committed content.
