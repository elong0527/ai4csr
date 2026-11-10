# AGENTS.md

## Purpose

This repository holds a Quarto book on designing AI-first workflows for clinical
study reporting and submission. It is written for Biometrics professionals in
biopharmaceutical companies and prepares them to own requirements, benchmarks,
risks, human oversight, and prototypes, and to work with AI engineers.

## Book structure

- The **Introduction** defines shared concepts once: AI-first workflow, AI
  agent, task contract, trustworthy assistance, and the AI-first SDLC.
- **Applied examples** are ordered by increasing workflow maturity. Give each
  chapter one teaching purpose; do not add an example that repeats another.
- Keep `_quarto.yml` in sync with the chapters.
- Propose a content map for approval before broad restructuring.

## Example chapters

- Run the six-stage lifecycle loop: Plan, Design, Build, Test, Deploy,
  Maintain. Each stage produces one artifact (workflow brief, task contract,
  prototype, benchmark report, release record, monitoring report) that shows the
  Biometrics decision, evidence, and human gate.
- Open with the problem, boundary, non-goals, and a maturity label: design
  pattern, reproducible prototype, comparative survey, or reference
  implementation. Never claim more maturity than the evidence supports.
- A motivating chapter may precede a lifecycle chapter. It runs no lifecycle and
  ends by naming the gaps the next chapter takes as requirements.
- Define benchmark success criteria before showing results, separate
  deterministic checks from model judgment, and report coverage.
- Pin external code references to a commit SHA, not a branch.
- Prefer synthetic or public data; never present it as real clinical data.
- Treat self-improvement as governed change: agents propose, humans approve.

## Writing style

- Write for Biometrics professionals, not AI engineers. Define technical terms
  on first use.
- Lead with the clinical problem and a concrete story.
- Distinguish agent actions from accountable human decisions.
- Avoid hype; attribute vendor claims.
- Recap foundational concepts with a cross-reference; do not redefine them.
- Keep production engineering details in optional callouts.

## Characters

Use ASCII only in every file; CI enforces this with `asciilint`. Write `---`,
`--`, and straight quotes, and let Pandoc typeset them. No emoji.

## Claims and sources

- Do not claim that the book, a model, a vendor, or a workflow is compliant,
  validated, or approved for GxP use. Detailed regulatory guidance is deferred.
- Do not invent facts, quotations, results, or references. Mark unsupported
  claims with `TODO`, and use first-party sources for product behavior.

## Delivery and verification

- Do not commit, push, or open a pull request unless asked.
- Search existing issues before creating one, and report the link.
- Set up the environment as described in `README.md`.
- Render the affected chapter, or the full book with `quarto render --to html`
  after structural changes, and read the warnings.
- Run `git diff --check` and `uvx asciilint@0.4.0 .`.
- After editing `diagrams/`, regenerate the SVGs with
  `python3 scripts/build-diagrams.py`.

## Slides

`slides/<event>-<date>/` holds standalone reveal.js decks, not book chapters.
Only the character and delivery rules apply to them.

## References

The AI-first SDLC adapts Anthropic's *AI-Native SDLC Playbook*. YAMAA
(<https://github.com/elong0527/yamaa>) is a reference implementation.
