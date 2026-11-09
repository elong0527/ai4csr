# Slides

Talk and workshop decks on AI-first workflows for clinical study reporting,
including the yamaa project. Each folder holds one Quarto reveal.js deck,
published with the book at `https://ai4csr.org/slides/<deck>/`.

| Deck | Title | Event |
| --- | --- | --- |
| [pilot7-2026-09-25](https://ai4csr.org/slides/pilot7-2026-09-25/) | Pilot 7 Synthetic Data Update | Update for the open source community, 2026-09-25 |
| [njsug-2026-10-09](https://ai4csr.org/slides/njsug-2026-10-09/) | yamaa: agentic workflow for CDISC data standardization | NJSUG and PhilaSUG Joint In-Person Meeting, 2026-10-09 |
| [slds-2026-11-03](https://ai4csr.org/slides/slds-2026-11-03/) | yamaa: agentic workflow for CDISC data standardization | SLDS 2026, New York, 2026-11-03 |
| [asa-boston-2026-11-12](https://ai4csr.org/slides/asa-boston-2026-11-12/) | AI-First Workflow: Starting from CDISC Data Standardization | 2026 Boston Pharmaceutical Statistics Symposium short course, 2026-11-12 |
| [deming-2026-12-07](https://ai4csr.org/slides/deming-2026-12-07/) | Towards an AI-First Workflow for Clinical Development and its Analysis and Reporting | 81st Annual Deming Conference on Applied Statistics, Session A, Atlantic City, 2026-12-07 |

The decks moved here from the yamaa repository's `docs/slides/` in November
2026; their earlier history is there, and the old yamaa addresses redirect
here.

## Layout

- `<event>-<date>/index.qmd` -- the deck, with its `custom.css` and any
  title-slide partial.
- `assets/images/` and `assets/diagrams/` -- images the decks share,
  referenced from a deck as `../assets/...`. The SVGs are maintained by hand,
  beside their Excalidraw source where one exists.

## Build

From a deck's folder:

```bash
quarto render index.qmd
```

The output is one self-contained `index.html` (`embed-resources: true`) and
is not committed. On every push to `main`, the Render and Publish workflow
renders each `slides/*/index.qmd` before the book, and the book publishes the
result through `resources: slides/` in `_quarto.yml`. Pull-request
verification renders the decks the same way.
