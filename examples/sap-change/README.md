# SAP change-review prototype (Pilot 1)

Traces one SAP requirement change (REQ-WIN-01: Week 24 analysis window
capped at Day 182) from the CDISCPILOT01 SAP through selection code to
CSR Table 14-3.01 in the RConsortium/submissions-pilot1 dev environment.

## Run

From this directory (base R only):

```sh
Rscript code/select_week24.R --sap=sap/REQ-WIN-01_v1.1.md --data=data/adadas_week24_extract.csv --out_selection=/tmp/sel.csv --out_summary=/tmp/sum.csv
Rscript benchmark/run-benchmark.R
Rscript benchmark/record-disposition.R --finding=F-01 --decision=accepted --reviewer="<name>"
```

The benchmark executes 7 cases and writes benchmark/benchmark-report.md.
Each run uses a fresh timestamped directory under benchmark/runs/
(e.g. runs/run-20260911-032101-<pid>/) for all intermediate outputs,
so a rerun never reads another run's files. Optional flags relocate
outputs without touching the repository's accepted evidence:

```sh
Rscript benchmark/run-benchmark.R --outdir=/tmp/sap-runs --report=/tmp/sap-report.md
```

## What is real and what is constructed

Real: the SAP Section 8.2 rule, the ADaM extracts, the Table 14-3.01
numbers, the analysis-code filter chain. Constructed: the v1.1 amendment
only. See provenance.md.

## Maturity

Reproducible-prototype evidence for the SAP example; the chapter prose is
not written yet.
