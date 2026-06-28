# Principles overview {#sec-principle-overview}

This chapter defines the first principles for designing an AI-first workflow.

The goal is not to replace clinical statisticians or programmers. The goal is to design work so an AI agent can perform a structured first pass, inspect real artifacts with tools, prepare evidence, and ask humans to make accountable decisions.

## What is an AI-first workflow?

An AI-first workflow represents work as inspectable artifacts, tracks explicit state, triggers agent action through events and rules, grounds reasoning in tools and evidence, and keeps humans accountable for judgment.

In this book, the agent is an **independent reviewer assistant**.

It can inspect, compare, prepare findings, rerun checks, and escalate judgment calls. It does not make final statistical decisions, sign off deliverables, or replace the responsible statistician or programmer.

## First principle 1: Inspectable artifacts

The workflow should use artifacts that humans and AI agents can inspect.

Artifacts should be readable, structured where possible, versioned, citable, and diffable.

Plaintext and structured metadata are useful because they make work easier to search, parse, compare, and cite.

Examples:

- SAP sections should be searchable and citable.
- ADaM metadata should expose dataset names, variable names, labels, types, codelists, and analysis flags.
- TLF outputs should have stable table IDs, titles, footnotes, and source references.
- Findings should be structured records, not only narrative comments.

> If the agent cannot inspect the work, it cannot reliably help with the work.

## First principle 2: Explicit state

The workflow should remember through artifacts, not through chat.

State should show:

- which artifact versions are current;
- what changed;
- what was checked;
- what findings were produced;
- what humans decided;
- what remains unresolved.

This matters because clinical study work changes repeatedly. Without explicit state, every agent run becomes a disconnected one-time review.

> The workflow state should be visible, reusable, and reviewable.

## First principle 3: Events and rules

The workflow should not depend only on manual prompting.

An **event** says something changed. A **rule** decides what the agent should do next.

| Event | Rule |
|---|---|
| SAP section updated | rerun affected SAP-to-TLF checks |
| ADaM metadata changed | rerun checks using changed variables |
| ADaM dataset refreshed | rerun affected population and value checks |
| TLF output regenerated | rerun affected TLF checks |
| Human asks for recheck | run the requested review |
| Another AI agent changes a deliverable | verify downstream impact |

> Events trigger attention; rules trigger action.

## First principle 4: Tools and evidence

The LLM should not guess what is in the study artifacts. Tools should expose the real content.

The LLM reasons. Tools observe. Evidence justifies.

Example tools:

- `parse_sap_requirements()`
- `inspect_adam_metadata()`
- `query_adam_population()`
- `extract_tlf_metadata()`
- `compare_expected_actual()`

A good finding should state what was checked, what was expected, what was observed, where the evidence came from, and who should review it.

> No finding without evidence.

## First principle 5: Human judgment

AI-first does not mean AI-only.

The agent prepares the review. Humans remain accountable for judgment.

The agent should escalate when SAP language is ambiguous, an artifact is missing, evidence conflicts, a decision requires statistical judgment, or the workflow rule does not cover the case.

> Agents prepare evidence; humans make accountable decisions.

## Applying the principles to SAP → ADaM → TLF review

The running example is an AI agent that reviews whether selected CSR TLF outputs derived from ADaM datasets follow the SAP.

### Workflow objective

Verify consistency across SAP requirements, ADaM metadata/data, and TLF outputs before database lock.

### Agent role

The agent is an independent reviewer assistant for clinical statisticians, statistical programmers, programming leads, and study reviewers.

### Inputs

- SAP version;
- ADaM metadata snapshot;
- ADaM dataset snapshot;
- TLF package;
- workflow rules;
- prior findings and decisions, if available.

### Example checks

| Check | Evidence |
|---|---|
| SAP population exists in ADaM | population flag in ADSL or relevant dataset |
| SAP endpoint variable exists | variable name, label, type, and codelist in ADaM metadata |
| TLF title matches intended display | title/subtitle from TLF output and SAP reference |
| TLF N values are explainable | counts from ADaM population rules |
| footnotes match analysis method | footnote text and SAP method section |
| rerun scope is justified | event and rule that triggered the run |

### Outputs

- evidence matrix;
- findings grouped by severity;
- escalation list by reviewer role;
- delta report showing fixed, new, repeated, and acknowledged findings.

## Summary

The first principles are:

1. **Inspectable artifacts**: make work readable, structured, versioned, citable, and diffable.
2. **Explicit state**: remember what changed, what was checked, and what was decided.
3. **Events and rules**: trigger the agent when work changes and define what action is needed.
4. **Tools and evidence**: inspect reality with tools and require evidence for findings.
5. **Human judgment**: agents prepare the review; humans make accountable decisions.

These principles keep the workflow simple, reviewable, and suitable for iterative clinical study work.
