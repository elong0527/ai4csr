# Review instructions: SAP change review

1. Confirm the claimed SAP version against the change manifest before
   reading any result. A version-stamp mismatch ends the review as
   limited; do not interpret stale numbers.
2. Re-derive the disposition table from the claimed SAP excerpt, the
   pinned data, and the pinned code. Compare against the presented
   output; any difference is a finding, not a rounding choice.
3. Separate deterministic comparisons (counts, stamps, hashes) from
   interpretation (whether the window change is clinically acceptable).
   Only the accountable reviewer decides the latter.
4. Check the control: the ITT row must be unchanged. Findings outside
   the affected scope are overreach; record them as such.
5. Record every finding in findings-state.json with status new, repeated,
   fixed, acknowledged, or unresolved. An acknowledged finding is not
   fixed; the next run must show it as repeated, not new.
6. Escalate on missing or ambiguous requirements. Never invent a window.
