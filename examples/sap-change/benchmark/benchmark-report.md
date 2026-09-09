# Benchmark report: SAP change review (prototype)

Rendered: 2026-09-09 00:33 UTC
Code version: v1.0 | R version: 4.5.3

Thresholds (agreed before evaluation): reproducibility exact match;
affected case PP delta +4 with ITT delta 0; control ITT delta 0;
stale output rejected by version stamp; missing window escalates.

## reproducibility: PASS

fresh runs match committed expected outputs

## affected-change: PASS

PP total 6 -> 10 (expected +4); ITT total 12 -> 12 (expected 0)

## unaffected-control: PASS

ITT row identical across versions; no finding raised outside affected scope

## stale-mismatch: PASS

output stamped v1.0 cannot satisfy a review claiming v1.1; result limited, version re-derivation required

## ambiguous-missing: PASS

windowless SAP excerpt refuses derivation with ESCALATE

## Coverage and limits

Cases executed: 5 of 4 defined; skipped: 0; failed: 0.
Deterministic comparisons only; no model judgment was evaluated.
Cost and latency were not measured.
