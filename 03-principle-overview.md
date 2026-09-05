# Principles overview {#sec-principle-overview}

This chapter defines the principles for designing an AI-first clinical study workflow.

The goal is not to replace clinical statisticians or programmers. The goal is to design work so an AI agent can perform a structured first pass, inspect real artifacts with tools, prepare evidence-backed findings, and ask humans to make accountable decisions.

## What is an AI-first workflow?

An AI-first workflow represents work as inspectable artifacts, tracks explicit state, triggers agent action through events and rules, grounds reasoning in tools and evidence, and keeps humans accountable for judgment.

In this book, the agent is an **independent reviewer assistant**.

It can inspect, compare, prepare findings, rerun checks, and escalate judgment calls. It does not make final statistical decisions, sign off deliverables, or replace the responsible statistician or programmer.

## Root principle: Trustworthy assistance

The first principle of an AI-first clinical workflow is **trustworthy assistance**.

Trustworthy assistance means the agent's work can be inspected, repeated, challenged, and reviewed. The agent should not rely on hidden memory, unsupported claims, or vague reasoning. It should work from visible artifacts, preserve explicit state, act through defined events and rules, use tools to gather evidence, and escalate judgment to accountable humans.

These principles do not replace organizational validation, quality systems, access control, audit trail requirements, or regulatory accountability. They describe how to design the working pattern so AI assistance remains inspectable and reviewable.

The remaining principles describe what trustworthy assistance requires in practice.

> A workflow is trustworthy when its inputs are visible, its actions are traceable, its findings are evidence-backed, and its limits are clear.

## Principle 1: Inspectable artifacts

Trust requires the agent and humans to inspect the same source materials.

The workflow should use artifacts that humans and AI agents can inspect. Artifacts should be readable, structured where possible, versioned, citable, and diffable.

Examples:

- SAP sections should be searchable and citable.
- ADaM metadata should expose dataset names, variable names, labels, types, codelists, and analysis flags.
- TLF outputs should have stable table IDs, titles, footnotes, and source references.
- Findings should be structured records, not only narrative comments.

> If the agent cannot inspect the work, it cannot reliably help with the work.

## Principle 2: Explicit state

Trust requires knowing what changed, what was checked, what was decided, and what remains unresolved.

The workflow should remember through artifacts, not through chat.

State should show:

- which artifact versions are current;
- what changed;
- what was checked;
- what findings were produced;
- what humans decided and why;
- what remains unresolved.

This matters because clinical study work changes repeatedly. Without explicit state, every agent run becomes a disconnected one-time review. With explicit state, the workflow can report which findings are new, repeated, fixed, acknowledged, or still open.

> The workflow state should be visible, reusable, and reviewable.

## Principle 3: Events and rules

Trust requires predictable triggers, not random or purely chat-driven action.

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

Without explicit triggers, review coverage depends on who remembered to ask. Events and rules make the workflow easier to repeat, explain, and audit.

> Events trigger attention; rules trigger action.

## Principle 4: Tools and evidence

Trust requires findings grounded in real SAP, ADaM, and TLF artifacts, not model memory or guesses.

The LLM should not guess what is in the study artifacts. Tools should expose the real content.

The LLM reasons. Tools observe. Evidence justifies.

Example tools:

- `parse_sap_requirements()`
- `inspect_adam_metadata()`
- `query_adam_population()`
- `extract_tlf_metadata()`
- `compare_expected_actual()`

A good finding should state what was checked, what was expected, what was observed, where the evidence came from, and who should review it. A finding without traceable evidence is not a finding; it is an unsupported opinion.

> No finding without evidence.

## Principle 5: Human judgment

Trust requires clear accountability.

AI-first does not mean AI-only.

The agent may identify discrepancies, assemble evidence, classify likely severity, and recommend who should review the issue. The accountable human role decides whether the finding is valid, whether the artifact should change, and how the decision should be documented.

The agent should escalate when SAP language is ambiguous, an artifact is missing, evidence conflicts, a decision requires statistical judgment, or the workflow rule does not cover the case.

> Agents prepare evidence; humans make accountable decisions.

## Applying the principles to SAP → ADaM → TLF review

The running example is an AI agent that reviews whether selected CSR TLF outputs derived from ADaM datasets follow the SAP.

### Workflow objective

Verify consistency across SAP requirements, ADaM metadata and data, and TLF outputs before database lock.

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
| SAP population definition is applied consistently | SAP population definition, ADaM flags, and TLF population counts |
| SAP endpoint variable exists | variable name, label, type, and codelist in ADaM metadata |
| Treatment group labels are consistent | SAP or TLF display labels and ADaM treatment variables |
| TLF title matches intended display | title and subtitle from TLF output and SAP reference |
| TLF N values are explainable | counts from ADaM population rules |
| Footnotes match analysis method | footnote text and SAP method section |
| Missing or imputed values are handled as specified | SAP method section, ADaM derivation metadata, and TLF footnotes |
| Rerun scope is justified | event and rule that triggered the run |

### Outputs

- evidence matrix;
- findings grouped by severity;
- escalation list by reviewer role;
- delta report showing fixed, new, repeated, and acknowledged findings.

### When the workflow should stop

The agent should not continue as if the review is complete when a required artifact is missing, SAP language is ambiguous, metadata cannot be inspected, or evidence conflicts across sources.

In those cases, the correct output is an escalation or limited finding, not a confident conclusion.

## Summary

The root principle is **trustworthy assistance**: the agent's work must be inspectable, repeatable, evidence-backed, and accountable.

The five derived principles are:

1. **Inspectable artifacts**: make work readable, structured, versioned, citable, and diffable.
2. **Explicit state**: remember what changed, what was checked, what was decided, and what remains unresolved.
3. **Events and rules**: trigger the agent when work changes and define what action is needed.
4. **Tools and evidence**: inspect reality with tools and require evidence for findings.
5. **Human judgment**: agents prepare the review; humans make accountable decisions.

Together, these principles keep AI-first clinical study workflows simple, reviewable, and trustworthy.
