# Benchmark report: SAP change review (Pilot 1 prototype)

Rendered: 2026-09-09 04:15 UTC
Code version: v2.0 | R version: 4.5.3

Thresholds (agreed before evaluation): exact selection match;
CSR Table 14-3.01 numbers reproduced (n 79/81/74, means 2.5/2.0/1.5, p 0.245);
amended selection 212 with 22 excluded; disposition control unchanged;
stale output rejected by version stamp; missing window escalates.

## exact-selection-match: PASS

re-derived Week 24 selection matches the committed v1.0 selection exactly, with SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified

## csr-numbers-match: PASS

summary matches CSR Table 14-3.01: n=79/81/74 means=2.5/2/1.5 dose-response p=0.245

## affected-change: PASS

amended window selects 212 subjects (22 excluded); low-dose mean moved 2.0 -> 1.9, dose-response p 0.245 -> 0.215

## disposition-control: PASS

ADSL disposition extract unchanged: 254 subjects, ITT 254; no finding outside affected scope

## stale-mismatch: PASS

v1.0-stamped selection presented for a v1.1 claim is rejected: REJECTED: selection stamped v1.0 cannot satisfy a review claiming v1.1

## ambiguous-missing: PASS

windowless SAP excerpt refuses selection with ESCALATE

## Coverage and limits

Cases executed: 6 of 6 defined; skipped: 0; failed: 0.
Deterministic comparisons only; no model judgment was evaluated.
Cost and latency were not measured.
