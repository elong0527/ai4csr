# AI for Clinical Study Reports and Submission

The book is available at <https://ai4csr.org/>.

This project is a work in progress, enriched by the community's collective efforts.
As you read this book, consider joining us as a contributor.
The quality of this resource relies heavily on your input and expertise.
We value your participation and contribution.

- Authors: contributed the majority of content to at least one chapter.
- Contributors: contributed at least one commit to the source code.
- [List of authors and contributors](https://ai4csr.org/01-preface.html#authors-and-contributors)

## Quick start

To explore code in this book, use the "Open in GitHub Codespaces" button below.

[![](https://github.com/codespaces/badge.svg)](https://codespaces.new/elong0527/ai4csr?quickstart=1&devcontainer_path=.devcontainer%2Fdevcontainer.json)

## Build the book

Restore and activate the virtual environment using `uv`:

```bash
uv sync
source .venv/bin/activate
```

Install the R dependencies declared in `DESCRIPTION`:

```bash
Rscript -e 'install.packages("pak", repos = "https://cloud.r-project.org")'
Rscript -e 'pak::pak("deps::.")'
```

When a chapter uses R and Python in the same document, point `reticulate` to
the project virtual environment:

```bash
export RETICULATE_PYTHON="$PWD/.venv/bin/python"
```

Render all formats:

```bash
quarto render
```

Render HTML only:

```bash
quarto render --to html
```

Render slides:

```bash
quarto render slides/<TBD>/index.qmd
```

### Environment and tool versions

Python is pinned by `.python-version` and locked by `uv.lock`; restore it
with `uv sync`. R packages come from `DESCRIPTION` and install unpinned from
CRAN, so an exact historical R package set is not guaranteed to reproduce.
A pull-request verification workflow (`.github/workflows/pr-verify.yml`) is
planned but not yet in place: once added, it will render the full HTML book
and run the deterministic example checks on every pull request without
publishing, and record the verified Quarto, R, Python, and uv versions in its
job summary. No vendor credentials or paid live model
calls are used. A fresh Codespaces/container launch has not been verified
yet.

Diagram sources live in `diagrams/*.excalidraw`. The SVGs under
`assets/diagrams/` are committed generated files: regenerate them with
`python3 scripts/build-diagrams.py` after changing a source, and never edit
them by hand.

## Maintenance

Update Python version:

```bash
uv python pin x.y.z
uv sync
```

Update dependencies:

```bash
uv lock --upgrade
uv sync
```
