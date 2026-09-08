# Learning assessment rubric

Assessment judges the participant's decisions, not coding speed and not the
prototype's performance. Prototype performance is recorded in the benchmark
report; learner assessment is recorded here.

## Learning criteria

A passing participant demonstrates all of the following on their chosen
scenario:

1. **Bounded trigger and scope.** States what starts the workflow, what is in
   scope, and explicit non-goals.
2. **Reviewable output.** Produces a brief, contract, and evaluation that
   another person can inspect without asking the author what was meant.
3. **Measurable success.** States success measures with denominators before
   results are observed.
4. **Separated responsibilities.** Labels what the deterministic check does,
   what the agent does, and what the human decides.
5. **Evidence and coverage.** Cites supporting evidence, reports coverage of
   rules and files, and names what was not checked. Silence is not evidence.
6. **Escalation.** Names at least one condition that stops the workflow or
   escalates to a human.
7. **Reasoned disposition.** Accepts, revises, or rejects with reasons tied to
   the evidence, including one unsupported-finding or missing-context case
   that requires clarification rather than confident completion.

## Scoring

Each criterion scores 0 (missing), 1 (partial), or 2 (complete). The
workshop-owner acceptance threshold is **10 of 14**, with criterion 7 required
to score at least 1. Thresholds are proposed until the workshop owner records
acceptance before the trial.

## Required cases

Every scenario evaluation must include:

- one **missing-context or unsupported-finding case** that the participant
  must clarify or escalate rather than complete confidently; and
- one **no-finding case** that still requires a coverage report.

## Learner versus prototype metrics

| Question | Recorded in | Metrics |
|---|---|---|
| Did the participant decide well? | This rubric | Criteria 1--7 above |
| Did the prototype perform well? | Benchmark report | Detection rate, false positives, missed findings, coverage, each with denominators; unavailable measurements labelled |

A confident, complete-looking answer that fails criterion 5 or 7 does not
pass, even when the prototype output looks correct.
