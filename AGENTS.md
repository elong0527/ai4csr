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

1. **Study-design anti-example:** explain why "study design" as a whole is not a
   well-defined AI-first workflow, then reframe it as design parameter ->
   analytical approximation -> simulation confirmation -> design report.
2. **Rounding:** encode and enforce explicit business rules in a small R
   workflow. This example spans three chapters that divide motivation, lifecycle
   design, and a hands-on lab.
   `06-workflow-rounding.qmd` is the motivating chapter: it states the rounding
   problem, writes the business rule down, sends one prompt to an agent, and
   ends by naming what a prompt cannot supply. It does not run the lifecycle.
   `07-workflow-rounding-skill.qmd` runs the lifecycle once, turning those named
   gaps into requirements and building the check as an agent skill.
   `08-workflow-rounding-lab.qmd` is a companion lab that exercises the
   prototype, schedule, state, identity, and issue policy without running a
   second lifecycle. Keep the three chapters as one example rather than three
   independent examples or multiple turns of a loop.
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

Every applied example runs the same six-stage, non-linear lifecycle. Use
these headings or close equivalents:

1. **Plan --- Frame the workflow**
2. **Design --- Specify the workflow**
3. **Build --- Prototype the workflow**
4. **Test --- Benchmark and evaluate**
5. **Deploy --- Operationalize the workflow**
6. **Maintain --- Monitor and improve**

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

An example may be preceded by a motivating chapter that states the problem,
records the business rule, and shows what an ad hoc prompt does and does not
accomplish. Such a chapter does not run the lifecycle stages and declares no
maturity level, because it proposes no workflow. It must end by naming the
specific gaps that the lifecycle chapter takes as requirements, and the
lifecycle chapter must open from those gaps. Do not use this exemption to
split a workflow design across chapters.

At the beginning of each lifecycle chapter, state:

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

An element may be marked not applicable when the chapter explains why. Within
a lifecycle chapter, do not omit stages silently.

## Maturity labels

Every lifecycle chapter declares one of these maturity levels near its
beginning. A motivating chapter declares none:

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

## Special requirements for the rounding example

The rounding chapters describe and distribute a teaching prototype.
`06-workflow-rounding.qmd` is the motivating chapter and declares no maturity
level; `07-workflow-rounding-skill.qmd` runs the lifecycle and is at
reproducible-prototype maturity; `08-workflow-rounding-lab.qmd` exercises the
same prototype and does not declare a separate workflow maturity level.

- Keep the division of material between the three chapters. Chapter 06 owns the
  problem, the cross-language tie table, BR-001, BR-002, and BR-003, and the
  scope clause defining which calls are in scope. It also owns the exploratory
  request, the first `arena.ai` prompt, the one-versus-eight call contrast, and
  the four gaps. Chapter 07 owns the task contract, the prototype, every pinned
  `file:line` result, the tie probe and its two causes, the benchmark, the
  release record, and monitoring. Do not move a task contract, benchmark, or
  release record into chapter 06. Chapter 08 owns the hands-on setup, skill
  invocation, offline controller exercise, agent adapter, 30-run rotation,
  issue lifecycle exercise, and monitoring questions. It applies the lifecycle
  artifacts from Chapter 07 rather than defining a second workflow.
- Present the open request in Chapter 06 as useful for discovery, not simply as
  a defective prompt. Chapter 07 combines a required minimum scan with a
  separately labeled exploratory pass. Repeatability does not require the
  agent to follow the same reasoning path on every run.
- Chapter 06 uses zero-decimal ties such as 2.5 in its prose so the teaching
  example stays simple. The one-decimal probe belongs in chapter 07, where both
  causes are visible; chapter 07 states why it changes precision.

- The repository ships the prototype under `exercise/rounding/`. Keep the
  skill, deterministic scripts, synthetic fixtures, schema, expected results,
  controller, issue publisher, tests, and inactive cron template consistent
  with Chapters 07 and 08. Do not describe the prototype as a validated,
  production-qualified, or operating system.
- The skill layout described in `07-workflow-rounding-skill.qmd` follows the
  Agent Skills specification (<https://agentskills.io/specification>): a
  required `SKILL.md` with `name` and `description` frontmatter, optional
  `scripts/`, `references/`, and `assets/` directories, and a `name` that
  matches the directory name.
- Every reader-facing prompt and every quoted file, line number, or result must
  be pinned to a commit SHA, never to a branch. metalite.ae is maintained, so an
  unpinned reference can silently stop reproducing. The chapters currently pin
  v0.1.4 at `bdb23d472b16bc9dadbc774e64c5ca40321e9c6b` (2026-09-01). Changing it
  means re-verifying every quoted line number and probe result in the same
  change.
- The scheduled controller may resolve a configured branch only to identify the
  current commit. Every generated agent prompt, report, finding, and issue
  action must record that exact SHA. A branch name alone is never evidence.
- The "Try it yourself" sections send a prompt to <https://arena.ai/agent>,
  matching the demonstration in `04-ai-agent.qmd`. State that no GitHub issue
  can be created there, and never present a specific agent response as the
  expected result. Prompt results vary between runs, and that variability is
  the point being taught.
- One Arena.ai response was manually copied into
  <https://github.com/Merck/metalite.ae/issues/249>. Link to it as an optional
  example for readers who do not want to wait for a new run. State that a person,
  not Arena.ai or the designed skill, posted it. Do not present it as the answer
  key, as evidence that the workflow was released, or as a finding approved by
  the package maintainers. BR-001 is an illustrative rule rather than a stated
  `metalite.ae` requirement. Use it to teach critical review: Chapter 07 explains
  why `R/fmt.R:37` and `R/format_ae_exp_adj.R:203` are not direct numeric
  formatting calls in the answer key. Do not carry the issue's proposed code
  into the book as a recommended solution without separate benchmarking.
- The repository contains an inactive cron template, not an installed schedule
  or active CI job. Publishing is disabled by default. Do not activate a
  schedule or perform a live GitHub issue action without separately confirming
  the configured service identity, process owner, repository permissions, and
  maintainer authorization. After release authorization, individual issue
  actions do not require separate approval, but the process owner retains
  authority to restrict or stop the workflow.
- Report a `formatC()` or `sprintf()` divergence as two distinct causes, tie
  mode and binary representation. Do not compress it into a claim that the
  function uses banker's rounding.

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
  Brief scenarios and guided exercises may use "you" or direct questions when
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
  "Further technical detail" sections.
- Use examples and concrete artifacts to explain abstract concepts.
- State an important limitation clearly and prominently once. Do not dilute it
  through defensive repetition in adjacent paragraphs.
- Keep headings descriptive and ensure each section advances the chapter's
  declared purpose.

### Character policy

Every file in this repository must be plain ASCII. The `asciilint` workflow in
`.github/workflows/asciilint.yml` fails a pull request that introduces a
character outside `U+0000-U+007F`, so a non-ASCII character blocks the merge
rather than reaching the manuscript.

Write the ASCII source and let Pandoc produce the typographic characters when
Quarto renders the book:

| Intended output | Write this in the source |
|---|---|
| Em dash | `---` |
| En dash | `--` |
| Curly double quotes | `"straight quotes"` |
| Curly single quotes or apostrophe | `'straight quotes'` |
| Ellipsis | `...` |

Additional rules:

- Do not paste text from a word processor, a browser, a PDF, or a chat window
  without converting the smart quotes, dashes, non-breaking spaces, and bullet
  characters it carries.
- Use ASCII in code, output, tables, and figure labels as well as in prose. In
  running text, spell out a symbol (`>=`, `+/-`, `micro`) or use LaTeX math such
  as `$\ge$` and `$\pm$` rather than the Unicode glyph.
- Keep diagram sources ASCII. Excalidraw stores label text as JSON, so a
  `\u2022` escape in `diagrams/*.excalidraw` is ASCII in the source file but
  becomes a literal bullet in the generated SVG under `assets/diagrams/`. Use an
  ASCII separator such as `|` or `-` in diagram labels instead.
- Do not use emoji.
- Pandoc applies this substitution to prose only. An attribute value, such as a
  Quarto callout `title="..."`, is copied verbatim into the HTML, so a `---`
  there reaches the reader as three hyphens. Rephrase with a colon or a comma
  instead.
- Character names and examples from non-Latin scripts belong in the text only
  when the book actually needs them. If a chapter ever does, propose the
  allowlist change in `asciilint.toml` for approval rather than adding the
  character silently.

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
- run `git diff --check`;
- run `uvx asciilint@0.4.0 .` and resolve every reported character before
  opening a pull request, because the same check runs in CI; and
- confirm that generated artifacts have not introduced unintended tracked
  changes.

For Python changes, run relevant checks with the project environment. The
repository currently has known Ruff style findings in
`scripts/build-diagrams.py`, so do not attribute those existing findings to a
manuscript-only change.

Edit diagram sources under `diagrams/`; the pre-render script generates the SVG
assets under `assets/diagrams/`. The generated SVG files are committed, so
regenerate them with `python3 scripts/build-diagrams.py` after a diagram change
and re-run `asciilint` on the result.

## Background references

Use these as design inputs, not as prescriptions that override the needs of a
Biometrics workflow. The source titles use "AI-native"; the book's canonical
term for its lifecycle is **AI-first SDLC**.

- Anthropic, *The AI-Native SDLC Playbook*: six-stage lifecycle, committed
  artifacts, continuous evaluation, and human gates.
  <https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction>
- Anthropic, *How Anthropic secures its AI-native software development
  lifecycle*: risk-based review, bounded access, monitoring, and governance.
  <https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle>
- YAMAA reference implementation: <https://github.com/elong0527/yamaa>
