# Expected impacts (stated before evaluation)

## Baseline reproduction (v1.0)

- Re-derived selection matches shipped ANL01FL exactly (234 subjects).
- Summary matches CSR Table 14-3.01: n 79/81/74, change means 2.5/2.0/1.5,
  dose-response p-value 0.245.

## Affected change (v1.0 -> v1.1)

- 22 subjects leave the Week 24 summary (late observed assessments after
  Day 182); 212 remain. Exclusions concentrate in xanomeline low dose.
- Low-dose mean moves 2.0 -> 1.9; dose-response p-value moves 0.245 -> 0.215.
- The v1.1 summary carries SAP_VERSION v1.1 and CODE_VERSION v2.0.
- Expected finding F-01 (new): Week-24 selection change with the evidence
  chain SAP Section 8.2 -> AWLO/AWHI -> ANL01FL -> Table 14-3.01 rows.

## Unaffected control

- ADSL extract matches its pinned control: 254 subjects, ITT 254. A
  reviewer flagging disposition overreaches; record and escalate the
  concern separately rather than treating it as evidence that the Week 24
  selection changed.

## Stale / mismatched artifact

- A v1.0-stamped selection presented for a v1.1 claim is rejected by the
  SAP_VERSION stamp. Expected result: limited, with re-derivation required.

## Ambiguous / missing requirement

- An SAP excerpt without window parameters refuses selection with an
  ESCALATE message. Expected result: escalation, not a guessed window.

## Acceptance thresholds

Exact selection match; CSR numbers reproduced; amended selection 212 with
22 excluded; control unchanged. Coverage: 6 of 6 defined cases, 0 skipped.
Cost and latency are not measured and are labelled as such.
