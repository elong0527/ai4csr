# Rounding: facilitator example (completed, with scoring notes)

> Facilitator-only. Worked with repository evidence from the rounding
> chapters. Scoring notes reference the assessment rubric criteria.

## 1. Workflow brief (completed)

- Artifact version: 1.0. Status: accepted. Date: 2026-09-08.
- **Trigger event:** an approved manual run or the inactive 30-attempt
  schedule selects one configured R source folder at an exact commit.
- **Non-goals:** activating the five-package schedule, validating statistical
  methods, replacing independent QC, automating human classification, BR-002
  or BR-003, GxP qualification.
- **Success measures:** preserve every catalog token; reject missing or
  fabricated source evidence; rotate after failures; reconcile unchanged
  clean results without suppressing a failed-closure retry.
- **Risk:** a narrow search produces a convincing false-clean report; the
  controller therefore re-validates catalog evidence against the pinned
  checkout before publication.
- **Decision:** accepted as a valuable, testable target. (Rubric criteria 1,
  2: complete.)

## 2. Task contract (completed)

- Artifact version: 1.0. Status: accepted. Brief version: 1.0.
- **Output:** JSON report with `file:line`, source expression, function,
  probe result, explanation or unresolved cause, discovery method, triage
  reason, coverage, environment, unchecked rules.
- **Boundaries:** read and test only; no source edits or policy changes. The
  agent cannot approve classifications or perform GitHub actions. The
  deterministic publisher acts only after validation and explicit per-run
  human acceptance through `--publish`.
- **Benchmark cases agreed before results:** ordinary violation, boundary tie
  of both signs, false-clean catalog, fabricated evidence, missing precision
  (escalate), clean package with coverage. (Rubric criteria 3, 4, 6:
  complete.)

## 3. Evaluation (completed)

- **Case A (missing precision):** disposition is escalate to the rule owner;
  the finding stays unresolved and the run is recorded. Confident completion
  here scores 0 on criterion 7.
- **Case B (clean package):** coverage statement lists files examined,
  catalog count, rules checked, and unchecked rules with reasons. Zero
  findings with this statement is a complete evaluation, not an empty one.
- **Disposition:** accept for a controlled advisory pilot; per-run human
  acceptance stays mandatory. (Rubric criteria 5, 7: complete.)
- **Prototype performance (recorded separately):** deterministic suite
  results with denominators live in the benchmark report, not in this
  learner assessment.
