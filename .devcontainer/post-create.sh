#!/usr/bin/env bash
# Contributor environment setup for the ai4csr dev container.
# Mirrors the "Build the book" steps in README.md.
set -euo pipefail

# Python: pinned by .python-version, locked by uv.lock.
uv sync

# R: installs the Imports declared in DESCRIPTION (knitr, reticulate,
# rmarkdown). These install unpinned from CRAN, so an exact historical R
# package set is not guaranteed to reproduce.
Rscript -e 'install.packages(c("knitr", "reticulate", "rmarkdown"), repos = "https://cloud.r-project.org")'

# System packages used by the book build.
sudo apt-get update -y -qq
sudo apt-get install -y libreoffice texlive texlive-luatex texlive-latex-extra texlive-fonts-extra
