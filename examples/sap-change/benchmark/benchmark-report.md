# Benchmark report: SAP change review (Pilot 1 prototype)

Run ID: 20260911-032144-236541 | Rundir: runs/run-20260911-032144-236541
Rendered: 2026-09-11 03:21 UTC
Code version: v2.0 | R version: 4.5.3
Identities (md5): select_week24.R c97826ea1b96cd0d03c3407b39222e86; adadas e6604bbd7d0d4e21b3f7b0f72b8e9c96; adsl 167994d347160d3897e33822a1dce758; sap-v1.0 7a06dfae82f4020dcbf1e648180938ab; sap-v1.1 eccc9ec0688f515567cae53e1a6e9def
Selector logs: runs/run-20260911-032144-236541/selector-v10.log, selector-v11.log, selector-missing-window.log, selector-omit-*.log

Thresholds (agreed before evaluation): exact selection match;
CSR Table 14-3.01 numbers reproduced (n 79/81/74, means 2.5/2.0/1.5, p 0.245);
amended selection 212 with 22 excluded; pinned disposition control matches;
stale selection and summary rejected by version stamp; missing window escalates;
each singly omitted window parameter escalates.

## exact-selection-match: PASS

re-derived Week 24 selection matches the committed v1.0 selection exactly, with SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified

## csr-numbers-match: PASS

summary matches CSR Table 14-3.01: n=79/81/74 means=2.5/2/1.5 dose-response p=0.245; SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified

## affected-change: PASS

amended window selects 212 subjects (22 excluded); low-dose mean moved 2.0 -> 1.9, dose-response p 0.245 -> 0.215; SAP_VERSION v1.1 and CODE_VERSION v2.0 stamps verified

## disposition-control: PASS

ADSL disposition extract matches the pinned control: 254 subjects, ITT 254; no finding outside affected scope

## stale-mismatch: PASS

v1.0-stamped selection and summary presented for a v1.1 claim are rejected: REJECTED: output stamped v1.0 cannot satisfy a review claiming v1.1; REJECTED: output stamped v1.0 cannot satisfy a review claiming v1.1

## ambiguous-missing: PASS

windowless SAP excerpt refuses selection with ESCALATE

## omitted-single-window: PASS

each singly omitted window parameter refuses selection with ESCALATE: WindowLower=refused; WindowUpper=refused; WindowTarget=refused

## Coverage and limits

Cases attempted: 7 of 7 defined; completed: 7; failed: 0; blocked: 0; skipped: 0.
Deterministic comparisons only; no model judgment was evaluated.
Cost and latency were not measured.
