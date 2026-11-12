# asa-boston-2026-11-12/part2 slides

"Language Models and Agents for Statistical Programming" -- Part 2 of the
[ASA Boston short course](../), presented by Jimeng Sun at the 2026 Boston
Pharmaceutical Statistics Symposium (2026-11-12).

[View the rendered slides](https://ai4csr.org/slides/asa-boston-2026-11-12/part2/)

## Source

The deck is the "lite" version of Jimeng Sun's standalone Part 2 deck
(`Part2_Jimeng_LLMs_Agents_StatProgramming_lite.qmd`, 2026-11-11), with
these changes for this repository:

- the speaker notes are removed (no `::: {.notes}` in the slide decks);
- non-ASCII characters are written as `--` or HTML entities in `index.qmd`
  and as numeric character references in the SVGs, so the rendered slides
  are unchanged;
- `course.css` is kept as `custom.css`, and the deck settings (size,
  fonts, logo, transition) and `title-slide.html` reproduce the standalone
  HTML.

The figure generator scripts and the PowerPoint versions stayed with the
original deck; `figures/` holds only the images the slides use.

## Build

The Render and Publish workflow renders the deck and publishes it with the
book at ai4csr.org. To preview locally: `quarto render index.qmd` from this
folder.
The output is one self-contained HTML file (`embed-resources: true`).
