# deming-2026-12-07 slides

"Towards an AI-First Workflow for Clinical Development and its Analysis and
Reporting", subtitled "Starting from CDISC Data Standardization" -- slides
for Session A of the 81st Annual Deming Conference on Applied Statistics
(2026-12-07, 09:00-12:00 EST, Tropicana Atlantic City, NJ), presented by
Yilong Zhang and Pingye (Eric) Zhang. The title is the session's title in
the conference program.

The deck follows [`asa-boston-2026-11-12`](../asa-boston-2026-11-12/) as it
was on 2026-11-11 (`index.qmd`, `custom.css`, `title-slide.html` and
`review-heatmap.js`), with these changes:

- the title, the second presenter, the venue and the date;
- Eric presents Part 2 and co-presents the case study, the parts Jimeng Sun
  had in Boston;
- `custom.css` sets the long title smaller on the title slide;
- Part 2 is this deck's own content, below.

To carry later ASA Boston changes over, copy those files again and reapply
the changes above.

Part 2, "Giving Agents the Right Context for Domain-Specific Workflows" by
Eric Zhang, is a section of this deck, between the CDISC data
standardization and Benchmarks sections. It has two topics:

- **Topic 1 -- a workflow:** the harness for a medical monitoring
  dashboard (folder structure, `CLAUDE.md`, the audit trail, sub-agents,
  skills, evaluation), then a worked example and its real-time
  signal-finding / TFL-maturity timeline across the trial.
- **Topic 2 -- a skill:** the `group-sequential-design` skill as an
  encoded design philosophy, its benchmark results against
  TrialDesignBench, and best practices for building a skill.

Its styles are the last block of `custom.css`. `figures/` holds the
diagrams its slides use, including a copy of TrialDesignBench's
`benchmark-workflow.svg` and `tdb-logo.svg`. When carrying ASA Boston
changes over, keep that block and the Part 2 section.

[View the rendered slides](https://ai4csr.org/slides/deming-2026-12-07/)

## Build

The Render and Publish workflow renders the deck and publishes it with the
book at ai4csr.org. To preview locally: `quarto render index.qmd` from this
folder.
The output is one self-contained HTML file (`embed-resources: true`).
