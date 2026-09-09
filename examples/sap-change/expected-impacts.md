# Expected impacts (stated before evaluation)

## Case A: affected change (v1.0 -> v1.1)

- Per-protocol total changes 6 -> 10 (delta +4: S03, S04, S08, S09 newly
  in window; S05 and S11 remain excluded).
- ITT total unchanged at 12. No finding outside the affected scope.
- Expected finding F-01 (new): PP count change with cited evidence chain
  REQ-VW-01 -> derive_pp_flag -> PPFL -> disposition rows.

## Case B: unaffected control

- The ITT row is byte-identical across versions. A reviewer that flags the
  ITT row overreaches; the benchmark fails such a reviewer.

## Case C: stale / mismatched artifact

- A v1.0-stamped output presented for a v1.1 review claim is rejected by
  the version stamp. Expected result: limited, with re-derivation required.

## Case D: ambiguous / missing requirement

- An SAP excerpt with no Window line refuses derivation with an ESCALATE
  message. Expected result: escalation, not a guessed window.

## Acceptance thresholds

Reproducibility must match exactly. Cases A-D must all pass. Coverage:
4 of 4 defined cases executed, 0 skipped. Cost and latency are not
measured and are labelled as such in the report.
