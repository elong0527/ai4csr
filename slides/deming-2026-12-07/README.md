# deming-2026-12-07 slides

"Towards an AI-First Workflow for Clinical Development and its Analysis and
Reporting", subtitled "Starting from CDISC Data Standardization" -- slides
for Session A of the 81st Annual Deming Conference on Applied Statistics
(2026-12-07, 09:00-12:00 EST, Tropicana Atlantic City, NJ), presented by
Yilong Zhang and Pingye (Eric) Zhang. The title is the session's title in
the conference program.

The deck starts as a copy of
[`asa-boston-2026-11-12`](../asa-boston-2026-11-12/) (2026-11-09), with the
title, presenters, venue, date and link changed; `custom.css` sets the long
title smaller on the title slide. Eric presents Part 2 and co-presents the
case studies, the parts Jimeng Sun had in Boston.

[View the rendered slides](https://ai4csr.org/slides/deming-2026-12-07/)

## Build

The Render and Publish workflow renders the deck and publishes it with the
book at ai4csr.org. To preview locally: `quarto render index.qmd` from this
folder.
The output is one self-contained HTML file (`embed-resources: true`).

## Short course format

The deck is written for a short course of about three hours for
statisticians and statistical programmers from biopharma companies. The
schedule slide gives each part's format, with a break after Part 1 and after
Part 2, and states no minutes, so the parts can be paced to the slot. Each
section slide carries a brief and what the part teaches, and every
participant activity opens with a tag naming its kind: a discussion with a
neighbour, or a hands-on exercise in the Codespace or the browser.

The hands-on exercises:

1. **Check your setup** (Welcome): the yamaa selftest in R, then start an
   agent.
2. **Run a specification, then break it** (Agentic CDISC data
   standardization): copy the `adam-advs-map` benchmark, run its
   specification, change the formula, and delete a filter to see a
   verification fail.
3. **Draft with an agent, then review** (same section): ask OpenCode,
   Claude Code, or Codex to add a pulse pressure record to the copied
   specification, then review the draft against four questions.
4. **Review a yamaa benchmark** and **review a Pilot 7 finding** (Case
   study: review and finalize): browser-only, through the public review
   pages.
5. **Read a job on Harbor Hub** (Case study: assessing an agent): classify a
   brief-prompt failure.

The answer keys were verified with engine 0.8.0 in R and Python: the
pulse pressure draft gives 15 rows with PP 40, 40 and 30, and the deleted
filter fails with `row_count_failed`.

## Outline

The deck has eight sections:

- **Welcome:** the schedule, disclaimer, training objectives, preparation,
  a setup check, and resources. It assumes familiarity with clinical
  development and CDISC standards, plus R programming experience. The
  preconfigured GitHub Codespace provides R with yamaa installed, OpenCode,
  Claude Code, and Codex.
- **AI Agents:** examples using arena.ai and the personal agent Muse,
  explanations of AI agents, large language models, and harnesses, and a
  vocabulary for the rest of the course.
- **AI-first workflow:** a mental game on building an AI-native biometrics
  group, the levels of AI adoption, AI-first, and AI-native work, a
  brainstorm on designing an AI-first workflow for CDISC data standardization
  (where to start building the agent, with its answer), and the design
  principles: trustworthy assistance, plain text first, deterministic first,
  and one source of truth.
- **Agentic CDISC data standardization:** the problem of one specification
  producing two results, its root cause, a discussion that finds an implicit
  rule in the participant's own work, the evidence that prompt completeness
  decides success, and the workflow's goal and principles. It introduces
  yamaa's planning-stage collaboration, YAML specifications, core principle,
  four components, and inheritance, then two hands-on exercises: run a
  specification and break it, and draft one with an agent and review it. It
  continues with the R Consortium submission pilots and Pilot 7, Pilot 5
  performance, and who does what in the workflow, and closes with a workflow
  summary.
- **AI evaluation:** designs an evaluation the way a statistician designs a
  study. It opens on the 133 of 134 full-prompt result ("would you sign
  off?") and a protocol map, then covers the objective (choose, improve, gate,
  monitor), the intervention (the whole deployed system), the population (what
  a benchmark is and the yamaa benchmarks), the endpoint (code, LLM-judge, and
  human grading), the conduct (how Harbor runs and grades an agent, with an
  invitation to the yamaa organization on Harbor Hub), bias and variance with a
  discussion of how far 133 of 134 can be trusted, rigor matched to risk, and
  the evidence for yamaa so far.
- **Case study: creating a benchmark for ADaM derivation:** the anatomy of
  the mean arterial pressure benchmark, its three prompt tiers, and rules for
  a fair benchmark.
- **Case study: review and finalize a benchmark:** how people review and
  finalize a yamaa SDTM, SEND, or ADaM benchmark through its review page, with the current round
  status, and how an AI-reported R Consortium Pilot 7 finding is reviewed and
  finalized.
- **Case study: assessing an agent with the benchmark:** per-task results
  for Muse Spark 1.3 from its Harbor Hub jobs, and an exercise on reading a
  job. The deck closes with the takeaways, where to go next, references,
  and a questions slide.
