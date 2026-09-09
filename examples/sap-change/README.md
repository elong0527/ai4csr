# SAP change-review prototype (synthetic)

Traces one SAP requirement change (REQ-VW-01: visit window +/- 3 days ->
+/- 7 days) to a small R program and a disposition table.

## Run

From this directory:

```sh
Rscript code/derive_pp.R --sap=sap/REQ-VW-01_v1.1.md --data=data/subjects.csv --out=/tmp/disposition.csv
Rscript benchmark/run-benchmark.R
Rscript benchmark/record-disposition.R --finding=F-01 --decision=accepted --reviewer="<name>"
```

Base R only. The benchmark executes 4 cases plus an exact
reproducibility check and writes benchmark/benchmark-report.md.

## Maturity

Reproducible-prototype evidence for the SAP example; the chapter prose is
not written yet. All records are synthetic.
