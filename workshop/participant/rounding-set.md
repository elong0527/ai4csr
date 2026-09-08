# Rounding: participant worksheet (brief + contract + evaluation)

> Complete one coherent set for the rounding workflow. Start from the
> pre-filled sections, fill every `TODO`, and keep all three artifacts about
> the same workflow: checking R code against the half-away-from-zero tie rule
> (BR-001) for displayed values and report decisions.

## 1. Workflow brief (partially completed)

- Artifact version: 0.1 (draft). Status: draft. Date: TODO.

**Problem and people affected.** Displayed percentages and row-selection
decisions in analysis outputs must round half away from zero. Silent
banker's-style ties erode trust in reported results.

**Current process and trigger event.** TODO: state how your team reviews
rounding today and what event starts this check.

**Minimum valuable workflow and non-goals.** One R source folder at a pinned
commit; checks `round()`, `signif()`, `formatC()`, `sprintf()`, `format()`,
`prettyNum()`, and `as.character()` calls against BR-001. Non-goals: TODO.

**Inputs, output, and decision owner.** TODO.

**Candidate success measures and baseline.** Every catalog call preserved
including multiple calls on one line; fabricated or missing source evidence
rejected; coverage reported on every run. Baseline: TODO.

**Assumptions, risks, and dependencies.** TODO: name one assumption and one
risk (hint: a narrow search can produce a convincing false-clean report).

**Biometrics decision required.** TODO: accept, revise, or stop?

## 2. Task contract (partially completed)

- Artifact version: 0.1 (draft). Status: draft. Workflow brief version: TODO.

**Objective.** Report candidate divergences from BR-001 in one named R source
folder at an exact commit.

**Trigger and stopping conditions.** TODO: name the trigger and two stop
conditions.

**Deterministic rules vs model tasks.** The scanner catalogs calls and the
probe recomputes ties deterministically; the agent explores beyond the
catalog and drafts explanations. TODO: state one thing the agent must never
decide.

**Tool access and prohibited actions.** Read and test only; no source edits
or policy changes. TODO: complete the allowed tool list.

**Evidence and coverage.** Every finding carries `file:line`, source
expression, probe result, and coverage; unresolved items stay open. TODO.

**Human review points.** TODO: who classifies each finding, and what happens
before any issue action?

## 3. Evaluation (two required cases)

**Case A (missing context).** The probe flags a `formatC()` divergence but
the required display precision for that output is not recorded. TODO: write
your disposition. Clarify or escalate; do not complete confidently.

**Case B (no finding, coverage required).** A clean package returns zero
findings. TODO: write the coverage statement you would still require
(files examined, rules checked, what was not covered).

**Biometrics decision required.** TODO: accept the candidate for a controlled
advisory pilot, revise, or reject, with reasons tied to the evidence above.
