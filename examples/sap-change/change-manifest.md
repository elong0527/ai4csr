# Change manifest: REQ-VW-01 visit-window amendment

Source requirement: REQ-VW-01 (visit-window rule for the Week 24 assessment).
Baseline: v1.0 (+/- 3 days). Changed: v1.1 (+/- 7 days, Amendment 1).

## Compatible artifact pairs

An agent must never combine a baseline SAP excerpt with changed results or
vice versa. The disposition output stamps its own sap_version; a review
claiming v1.1 must present output stamped v1.1.

| Pair | SAP excerpt | Data | Code | Expected output |
|---|---|---|---|---|
| Baseline | REQ-VW-01_v1.0.md | subjects.csv | derive_pp.R v1.0 | disposition_v1.0.csv |
| Changed | REQ-VW-01_v1.1.md | subjects.csv | derive_pp.R v1.0 | disposition_v1.1.csv |

## Fixture manifest (sha256)

- sap/REQ-VW-01_v1.0.md: 89b34ca853f1274dbcbc08f4b541bddb5c00f2b808477b6af6bab4d32ef7980f
- sap/REQ-VW-01_v1.1.md: b1158379db98d975a29aa503b90402e8a48be1157467c58bd6466a3308286cc7
- data/subjects.csv: b182488ddec29b216ba8abffe8831bddb6ed1a51aaaee8cbfbea4c2611d4fdd0
- code/derive_pp.R: 8788525967329192fd2a41e40a37e78c1a8c9507616742335cc33b17c481970c
- outputs/disposition_v1.0.csv: e9476fc79f547d47e5b8effc4bcdccfe2f36050272b3c9990a728aabd617f150
- outputs/disposition_v1.1.csv: 8070e5a8f18e1e82f57d307347fc25d9a37792f4de506d43bf877e5035446308

Regenerate with: sha256sum sap/* data/* code/* outputs/*

## Stable identifiers

REQ-VW-01 -> code symbol derive_pp_flag -> data field PPFL ->
disposition table per-protocol rows. Every finding cites this chain.
