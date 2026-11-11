# asa-boston-2026-11-12 slides

"AI-First Workflow", subtitled "Starting from CDISC Data Standardization" --
workshop slides for the 2026 Boston Pharmaceutical Statistics Symposium
(2026-11-12).

[View the rendered slides](https://ai4csr.org/slides/asa-boston-2026-11-12/)

## Build

The Render and Publish workflow renders the deck and publishes it with the
book at ai4csr.org. To preview locally: `quarto render index.qmd` from this
folder.
The output is one self-contained HTML file (`embed-resources: true`).

## Short course format

The deck is written for a short course of about three hours for
statisticians and statistical programmers from biopharma companies. The
outline slide gives each part's topics and instructor, with a break after
Part 1 and after Part 2, and states no minutes, so the parts can be paced to
the slot. Each section slide carries a brief of what the part teaches.

The case study walks through two public review pages in the browser:
reviewing a yamaa benchmark and reviewing an R Consortium Pilot 7 finding.
The Harbor slide links to the yamaa jobs on Harbor Hub for a live demo.

## Outline

The deck has six sections and an appendix:

- **Welcome:** the outline, disclaimer, training objectives, and resources.
- **AI agents:** examples using arena.ai and the personal agent Muse,
  explanations of AI agents, large language models, and harnesses, and a
  vocabulary for the rest of the course.
- **AI-first workflow:** a mental game on building an AI-native biometrics
  group, the levels of AI adoption, AI-first, and AI-native work, a
  brainstorm on where to start building an agent for CDISC data
  standardization, with its answer, and the design principles that serve
  trustworthy assistance.
- **Agentic CDISC data standardization:** two agents producing two results
  from one specification, the root cause (implicit business rules), the
  evidence that prompt completeness decides success, and the mean arterial
  pressure example. It then introduces yamaa: planning-stage collaboration,
  a YAML specification, the core principle, where the uncertainty lives,
  inheritance, and Pilot 5 performance, and closes with the workflow as a
  loop (`workflow-summary.svg`).
- **Benchmarks:** what a benchmark is, drawn as double programming
  (`benchmark-concept.svg`); the expectations for an SDTM and ADaM
  benchmark; the yamaa benchmarks; how Harbor runs and grades an agent; the
  limitations of a benchmark; and the path from benchmarks to real studies.
- **Case study: reviewing benchmarks:** the two benchmarks side by side; how
  people review and approve a yamaa benchmark (`benchmark-review.svg`), with
  a walkthrough and a live review heatmap drawn by `review-heatmap.js`; and
  how people decide on AI-reported Pilot 7 findings (`pilot7-review.svg`),
  with a walkthrough. The deck closes with the takeaways, where to go next,
  references, and a questions slide.
- **Appendix:** preparation and the Codespace check, yamaa's four
  components, the R Consortium submission pilots and Pilot 7 studies, and
  the objective, intervention, and endpoint of an AI evaluation.
