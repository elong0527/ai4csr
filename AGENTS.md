# AGENTS.md

## Purpose

This repository contains a book about designing AI-first workflows for clinical
study reporting and submission.

The primary audience is members of Biometrics departments in biopharmaceutical
companies. The book should help them:

- define a useful, bounded AI-first workflow;
- state what should be built and how success will be measured;
- build and evaluate a prototype;
- communicate effectively with AI engineers throughout planning, development,
  deployment, and monitoring; and
- establish a foundation for later regulatory and quality recommendations.

The main objective is to prepare readers to own requirements, benchmarks,
risks, oversight, and prototypes. Production implementation is useful context,
but it is optional technical depth rather than a prerequisite for every reader.

## Book architecture

Organize the book in two main parts.

### Introduction

The Introduction defines shared concepts once. It should cover:

- what an AI-first workflow is and how it differs from an ad hoc AI task;
- what an AI agent is, including the roles of the model, harness, tools,
  context, state, and accessible environment;
- the task contract: objective, inputs, scope, outputs, boundaries, and
  escalation conditions;
- the principles of trustworthy assistance;
- the shared AI-first software development lifecycle (AI-first SDLC) used by
  the examples.

The KEYNOTE-189 age-summary exercise in `04-ai-agent.qmd` is an AI-adoption
demonstration, not an AI-first workflow example. Keep it in the Introduction to
show what a single Arena.ai prompt can accomplish and to motivate the move from
a prompt to a governed, repeatable workflow. Do not force this demonstration
into the shared lifecycle or give it a workflow maturity label.

### Applied examples

Use one **Applied examples** part initially. Each example should normally be one
chapter. Split an example across chapters only when its scope becomes too large
for a coherent chapter. Introduce thematic parts only after enough examples
exist to justify them.

Order the current and planned examples by increasing workflow maturity:

1. **Study-design anti-example:** explain why “study design” as a whole is not a
   well-defined AI-first workflow, then reframe it as design parameter ->
   analytical approximation -> simulation confirmation -> design report.
2. **Rounding:** encode and enforce explicit business rules in a small R
   workflow.
3. **Agentic R code review:** survey and benchmark mature code-review workflows
   in Codex, Claude Code, and GitHub Copilot.
4. **SAP -> code -> results:** manage changes and traceability across connected
   artifacts.
5. **YAMAA:** illustrate a governed, self-improving workflow in which approved
   business rules guide the work and feedback closes the loop.

When adding an example, identify its distinct teaching purpose and place it in
the maturity progression. Do not add a chapter that merely repeats an existing
example with different terminology.

## Shared lifecycle for example chapters

Every applied example follows the same six-stage, non-linear lifecycle. Use
these headings or close equivalents:

1. **Plan — Frame the workflow**
2. **Design — Specify the workflow**
3. **Build — Prototype the workflow**
4. **Test — Benchmark and evaluate**
5. **Deploy — Operationalize the workflow**
6. **Maintain — Monitor and improve**

The lifecycle is a loop. Monitoring, incidents, approved feedback, and changed
requirements can initiate a new planning cycle.

Use one canonical artifact as the organizing spine for each stage:

1. **Plan:** workflow brief.
2. **Design:** task contract.
3. **Build:** prototype.
4. **Test:** benchmark report.
5. **Deploy:** release record.
6. **Maintain:** monitoring report.

Treat an artifact as committed when it is durable, versioned, reviewable, and
accepted into the applicable system of record; a Git commit is not required.
The accepted artifact provides the handoff or event for the next stage. Keep
the Biometrics decision, engineering contribution, supporting evidence, and
human gate visible in every artifact.

At the beginning of each example chapter, state:

- the problem and learning objective;
- the workflow boundary and explicit non-goals;
- why the work is, or is not yet, a well-defined AI-first workflow; and
- the chapter's maturity level.

Within each lifecycle stage, cover:

- the purpose of the stage;
- inputs and required context;
- the agent's role and the accountable human role;
- the artifact produced by the stage;
- applicable business rules and approval gates;
- evidence or benchmarks;
- risks, limitations, and unresolved questions; and
- the event or accepted artifact that initiates the next stage.

An element may be marked not applicable when the chapter explains why. Do not
omit lifecycle stages silently.

## Maturity labels

Every example chapter declares one of these maturity levels near its beginning:

- **Design pattern:** a conceptual workflow with explicit assumptions and gaps.
- **Reproducible prototype:** runnable code, synthetic data, expected results,
  and benchmark criteria.
- **Comparative survey:** a time-stamped comparison evaluated against a shared
  benchmark.
- **Reference implementation:** a maintained implementation in this or another
  repository.

Do not imply a higher maturity level than the evidence supports. A prototype is
not a validated production system, and a reference implementation is not proof
that an organization has qualified it for a specific intended use.

## Content alignment and duplication

Treat the book as one connected argument, not a collection of independent
articles.

- Give every chapter one primary teaching purpose.
- Keep the authoritative explanation of a foundational concept in the
  Introduction.
- Make example chapters lightly standalone: provide a one- or two-sentence
  recap and a cross-reference before applying a foundational concept.
- Do not redefine agents, AI-first workflows, human accountability, task
  contracts, or the lifecycle at length in every chapter.
- Use consistent names for concepts, lifecycle stages, artifacts, roles, and
  controls throughout the book.
- Check adjacent chapters and likely cross-references before adding material.
- Preserve unique examples, evidence, and explanations when consolidating
  duplicated text.
- Update `_quarto.yml` whenever chapters are added, removed, renamed, moved, or
  reordered.

Before broad restructuring, review the current manuscript and present a
book-level content map for approval. The map should show each chapter's purpose,
material to keep, material to move, overlap to remove, and missing content.
Small local improvements do not require a separate content-map proposal.

The current part names are not permanent constraints. Reassess them when enough
applied examples exist to justify thematic parts.

## Regulatory perspective

Detailed regulatory and quality recommendations are deferred until the core
concepts and examples are more mature. Do not require a dedicated regulatory
chapter or a regulatory section in every example during the current stage of
development.

The FDA warning-letter callout in `02-ai-first.qmd` is an intentional exception.
Keep it as a concrete illustration that AI output does not transfer human
responsibility or approval authority.

Until the deferred topic is developed, do not claim that the book, an example,
a model, a vendor, a cloud provider, or a workflow is compliant, validated, or
approved for GxP use. Treat any regulatory expansion as separately scoped
future work rather than adding it incidentally to unrelated chapters.

## Special requirements for the code-review survey

The agentic code-review chapter is a comparative survey and a mature-workflow
example, not a vendor tutorial or ranking based on marketing claims.

- Use the same controlled, synthetic R pull request for Codex, Claude Code, and
  GitHub Copilot.
- Seed known defects representative of Biometrics work and preserve a hidden or
  independently maintained answer key.
- Compare review triggers, available context, repository instructions,
  execution process, findings, suggested fixes, human gates, and feedback
  loops.
- Evaluate defect detection, false positives, missed defects, severity,
  actionability, reproducibility, coverage, latency, and cost when the evidence
  is available.
- Date the comparison and verify product behavior against current first-party
  documentation because these products change frequently.
- Explain why each design choice makes sense and identify gaps that remain even
  when the implementation behaves as documented.

## Examples, benchmarks, and self-improvement

- Prefer synthetic or public data that can be distributed with the book.
- Never imply that synthetic teaching data are submission-ready clinical data.
- When synthetic data are paired with a real study artifact, state prominently
  that the data contain no real participant records and cannot support a
  conclusion about the actual study. Describe the real artifact as teaching
  context, and avoid repeating the same disclaimer throughout the example.
- Make benchmark success criteria explicit during planning, before presenting
  results.
- Separate deterministic checks from model judgment and record which produced
  each finding.
- Require coverage reporting; silence is not evidence that every rule or file
  was checked.
- Treat self-improvement as a governed change process. Agents may propose rule,
  instruction, test, or workflow updates, but accountable humans approve policy
  changes before they become active.
- For YAMAA, use the maintained project as a reference implementation while
  distinguishing its current behavior from the book's proposed workflow.

## Writing style

- Use a professional voice for definitions, requirements, and conclusions.
  Brief scenarios and guided exercises may use “you” or direct questions when
  placing the reader in a concrete role makes the lesson easier to understand.
  Return to objective prose after the scenario.
- Write for Biometrics professionals rather than AI engineers.
- Use plain, direct language and define AI or software terms on first use.
- Begin with the clinical workflow problem before introducing technology.
- Prefer a recognizable clinical story before an abstract explanation. Retain
  useful details such as the team role, assignment, protocol, SAP, SOPs, data,
  and review questions rather than compressing them into a generic task.
- Use analogies and diagnostic questions to make unfamiliar agent concepts
  concrete, while keeping actual agent capabilities and human accountability
  explicit.
- Avoid hype, vendor marketing language, and unsupported claims.
- Clearly distinguish agent actions from accountable human decisions.
- Keep the main narrative focused on requirements, prototypes, evidence, and
  evaluation.
- Put production engineering details in optional technical callouts or
  “Further technical detail” sections.
- Use examples and concrete artifacts to explain abstract concepts.
- State an important limitation clearly and prominently once. Do not dilute it
  through defensive repetition in adjacent paragraphs.
- Keep headings descriptive and ensure each section advances the chapter's
  declared purpose.

## Sources during early development

The manuscript is at an early stage. Do not block useful drafting on a complete
citation review.

- Do not invent facts, quotations, results, or references.
- Add a source when one is readily available.
- Mark unfinished or unsupported claims with a visible `TODO`.
- Attribute vendor-reported performance rather than presenting it as
  independent evidence.
- Use current first-party sources for time-sensitive product behavior.
- Plan a formal citation, technical, and regulatory review before publication.

## GitHub issues and delivery

Agents may create clearly scoped GitHub issues directly when needed.

- Search open and closed issues before creating a new issue.
- Create issues for significant content gaps, cross-chapter dependencies,
  unresolved editorial decisions, future examples, or deferred validation and
  publication-readiness work.
- Include the context, affected chapters, intended outcome, and acceptance
  criteria.
- Do not create an issue for a small edit that can be completed safely in the
  current task.
- Report the issue link after creation.

By default, edit and verify the local working tree. Do not commit, push, or open
a pull request unless explicitly requested.

## Local development and verification

Follow `README.md` for environment setup.

```bash
uv sync --locked
source .venv/bin/activate
export RETICULATE_PYTHON="$PWD/.venv/bin/python"
```

For manuscript changes:

- render the affected chapter when practical;
- run a full `quarto render --to html` after structural, navigation,
  cross-reference, bibliography, shared-style, or diagram changes;
- inspect warnings and the rendered result, not only the command exit code;
- run `git diff --check`; and
- confirm that generated artifacts have not introduced unintended tracked
  changes.

For Python changes, run relevant checks with the project environment. The
repository currently has known Ruff style findings in
`scripts/build-diagrams.py`, so do not attribute those existing findings to a
manuscript-only change.

Edit diagram sources under `diagrams/`; the pre-render script generates the SVG
assets under `assets/diagrams/`.

## Background references

Use these as design inputs, not as prescriptions that override the needs of a
Biometrics workflow. The source titles use “AI-native”; the book's canonical
term for its lifecycle is **AI-first SDLC**.

- Anthropic, *The AI-Native SDLC Playbook*: six-stage lifecycle, committed
  artifacts, continuous evaluation, and human gates.
  <https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction>
- Anthropic, *How Anthropic secures its AI-native software development
  lifecycle*: risk-based review, bounded access, monitoring, and governance.
  <https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle>
- YAMAA reference implementation: <https://github.com/elong0527/yamaa>
