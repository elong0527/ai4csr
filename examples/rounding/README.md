# Deterministic-first rounding review

This example develops the workflow artifacts before changing the book chapter.
It uses real R functions in a synthetic teaching policy:

- `janitor::round_half_up()` is approved;
- `base::round()` is prohibited; and
- `base::mean()` and `stats::median()` are known non-rounding calls.

The classifications are teaching decisions, not universal recommendations.
Their policy rows include owners, version-review requirements, rationales, and
primary documentation links.

## Stage 1: deterministic CI gate

The gate inventories every function call in changed first-party R code and
classifies exact matches against `rules/rounding-policy.csv`:

- known prohibited calls fail without invoking an agent;
- fully classified allowed calls pass without invoking an agent; and
- unresolved calls pass to a bounded agent queue.

Run a scenario from the repository root:

```bash
Rscript examples/rounding/run-ci-gate.R \
  examples/rounding/fixtures/unresolved.R
```

## Stage 2: agent review

The instructions in `agent/review-instructions.md` receive only
`results/agent-queue.csv`. The checked-in review is expected teaching output,
not a live model result. The agent can propose a policy update, but the
standards owner approves changes to the active policy.

The prototype does not inspect code inside packages or dependencies. Package
versions, transitive source, compiled code, and runtime behavior require a
separately scoped workflow.

The repository workflow at `.github/workflows/rounding-policy-example.yml` runs
the deterministic tests and gate first. Its agent-handoff job becomes eligible
only when the gate succeeds and emits unresolved calls. The job marks the
integration boundary; it does not call a model or consume tokens.
