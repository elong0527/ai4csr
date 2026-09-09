# Change manifest: REQ-WIN-01 Week-24 window amendment

Source requirement: REQ-WIN-01 (SAP Section 8.2 Week-24 analysis window).
Baseline: v1.0 (after Day 140, target Day 168, no upper bound).
Changed: v1.1, a CONSTRUCTED teaching amendment capping the window at
Day 182. Not a real protocol change.

## Compatible artifact pairs

A review claiming v1.1 must present output stamped v1.1. A v1.0-stamped
selection presented for a v1.1 claim is rejected without interpretation.

| Pair | SAP excerpt | Data | Code | Expected output |
|---|---|---|---|---|
| Baseline | REQ-WIN-01_v1.0.md | adadas_week24_extract.csv | select_week24.R v2.0 | selection_v1.0.csv |
| Changed | REQ-WIN-01_v1.1.md | adadas_week24_extract.csv | select_week24.R v2.0 | selection_v1.1.csv |

## Stable identifiers

SAP Section 8.2 -> AWLO/AWHI/AWTARGET -> ANL01FL -> tlf-primary.Rmd Step 2
filter -> CSR Table 14-3.01 rows. Every finding cites this chain.

## Fixture manifest (sha256)

Regenerate with: sha256sum sap/* data/* code/* outputs/* (excluding runs/)

- sap/REQ-WIN-01_v1.0.md, sap/REQ-WIN-01_v1.1.md: paraphrased excerpts, see provenance.md
- data/adsl_extract.csv: eb9652e0b2affca97114c24aa79f1f9e6d679d97dc2459b11b414dc5edab42c6
- data/adadas_week24_extract.csv: f0c6a0baf7b9f25bdebc15922c8a378db4cd02d3fc411feee399d4d73e07f914
