# deming-2026-12-07/part2 slides

"Giving Agents the Right Context for Domain-Specific Workflows" -- Part 2
of the [81st Annual Deming Conference workshop](../), presented by Pingye
(Eric) Zhang at the 81st Annual Deming Conference on Applied Statistics
(2026-12-07).

[View the rendered slides](https://ai4csr.org/slides/deming-2026-12-07/part2/)

## Source

Built directly for this repository in two topics:

- **Topic 1 -- a workflow:** the harness for a medical monitoring
  dashboard (folder structure, `CLAUDE.md`, the audit trail, sub-agents,
  skills, evaluation), then a worked example and its real-time
  signal-finding / TFL-maturity timeline across the trial.
- **Topic 2 -- a skill:** the `group-sequential-design` skill as an
  encoded design philosophy, its benchmark results against
  TrialDesignBench, and best practices for building a skill.

`title-slide.html` and the deck settings (size, fonts, logo, transition)
follow the same pattern as [`asa-boston-2026-11-12/part2`](../../asa-boston-2026-11-12/part2/);
`custom.css` is this deck's own `custom.css` plus this part's additions.
`figures/` holds the diagrams this part's slides use, including a copy of
TrialDesignBench's `benchmark-workflow.svg` and `tdb-logo.svg`.

## Build

The Render and Publish workflow renders the deck and publishes it with the
book at ai4csr.org. To preview locally: `quarto render index.qmd` from this
folder.
The output is one self-contained HTML file (`embed-resources: true`).
