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
- use AI with appropriate confidence in a regulated environment.

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
- the shared AI-native development lifecycle used by the examples; and
- a dedicated regulatory perspective for AI-assisted work in Biometrics.

Do not place a detailed applied example in the Introduction when it can be a
lifecycle example chapter. The concepts and task-contract material currently in
`intro-ai-agent.qmd` belong in the Introduction; its KEYNOTE-189 age-summary
exercise should become the first applied example.

### Applied examples

Use one **Applied examples** part initially. Each example should normally be one
chapter. Split an example across chapters only when its scope becomes too large
for a coherent chapter. Introduce thematic parts only after enough examples
exist to justify them.

Order the current and planned examples by increasing workflow maturity:

1. **Age summary:** a bounded read, compute, and review workflow using the
   synthetic KEYNOTE-189 teaching data.
2. **Study-design anti-example:** explain why “study design” as a whole is not a
   well-defined AI-first workflow, then reframe it as design parameter ->
   analytical approximation -> simulation confirmation -> design report.
3. **Rounding:** encode and enforce explicit business rules in a small R
   workflow.
4. **Agentic R code review:** survey and benchmark mature code-review workflows
   in Codex, Claude Code, and GitHub Copilot.
5. **SAP -> code -> results:** manage changes and traceability across connected
   artifacts.
6. **YAMAA:** illustrate a governed, self-improving workflow in which approved
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

The current part names and placeholder chapters are not permanent constraints.
In particular, reassess `docs-overview.qmd`, `reporting-overview.qmd`, and the
unlisted `wholegame.md` when preparing the content map. Do not delete their
unique material without first assigning it a destination or documenting why it
is no longer needed.

## Regulatory perspective

The book provides educational recommendations from a regulatory and quality
perspective. It must not claim that the book, an example, a model, a vendor, a
cloud provider, or a workflow is compliant, validated, or approved for GxP use.

Use two layers:

1. Maintain a dedicated Introduction chapter for the shared regulatory and
   quality considerations.
2. Include a concise **Regulatory perspective** section in every example
   chapter that applies those considerations to the example.

Apply these principles consistently:

- The agent assists; accountable humans retain responsibility for decisions,
  approvals, and intended use.
- Existing quality systems and GxP processes continue to govern the work.
- Controls should be proportionate to intended use, risk, and the consequence
  of an incorrect result.
- Delegating work to a vendor or agent does not delegate the responsible
  organization's accountability.
- Describe cloud and model choices as deployment options that require
  organization-specific assessment. Do not call a provider inherently “GxP
  compliant.”
- Data-leakage risk can be mitigated through combinations of data minimization,
  approved internal environments, internally deployed open-weight models,
  assessed cloud services, contractual controls, access controls, and technical
  monitoring.
- Address data classification, confidentiality, retention, provenance,
  traceability, reproducibility, audit trails, identity, least privilege,
  separation of duties, vendor oversight, validation or qualification for
  intended use, versioning, change control, incident handling, business
  continuity, and ongoing monitoring when relevant.
- State residual risks, assumptions, and limitations. Mitigation is not a claim
  that risk has been eliminated.

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

- Use an objective, professional voice. Avoid second-person address, including
  “you” and “your,” except inside a quoted prompt or source.
- Write for Biometrics professionals rather than AI engineers.
- Use plain, direct language and define AI or software terms on first use.
- Begin with the clinical workflow problem before introducing technology.
- Avoid hype, anthropomorphism, vendor marketing language, and unsupported
  claims.
- Clearly distinguish agent actions from accountable human decisions.
- Keep the main narrative focused on requirements, prototypes, evidence, and
  evaluation.
- Put production engineering details in optional technical callouts or
  “Further technical detail” sections.
- Use examples and concrete artifacts to explain abstract concepts.
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
regulated Biometrics workflow:

- Anthropic, *The AI-Native SDLC Playbook*: six-stage lifecycle, committed
  artifacts, continuous evaluation, and human gates.
  <https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction>
- Anthropic, *How Anthropic secures its AI-native software development
  lifecycle*: risk-based review, bounded access, monitoring, and governance.
  <https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle>
- YAMAA reference implementation: <https://github.com/elong0527/yamaa>
