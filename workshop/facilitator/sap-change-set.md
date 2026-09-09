# SAP change review: facilitator answers

> Facilitator-only. This answer set applies to the synthetic teaching
> prototype in `examples/sap-change/`. The extracts contain no real
> participant records. The prototype teaches traceability and review
> boundaries; it does not support a conclusion about an actual study.

## 1. Change and potential impact

The constructed v1.1 requirement narrows the Week 24 upper window from
Day 196 to Day 182. The potential effect is selection of ADADAS records
for the Week 24 analysis and therefore Table 14-3.01 rows; it does not
change the ADSL disposition extract.

## 2. Evidence-chain answer

For F-01, the expected chain is:

```text
REQ-WIN-01 v1.1 Section 8.2 -> AWLO/AWHI/AWTARGET -> ANL01FL -> Table 14-3.01 rows
```

The reviewer should be able to inspect the v1.1 SAP excerpt, the selected
rows and their window variables, the generated selection and summary, and
the benchmark report. If any link is absent or uses a different SAP or code
version, the finding remains unresolved and requires re-derivation.

## 3. Challenge answers

- A v1.0 selection or summary cannot satisfy a v1.1 claim. Its
  `SAP_VERSION` stamp identifies it as stale; reject the claim and request
  a v1.1 re-derivation.
- A disposition concern is outside this requirement's affected scope. The
  reviewer records it as an overreach rather than treating it as evidence
  that the Week 24 rule changed. The pinned ADSL control is checked
  separately; a genuine ADSL change requires escalation.

## 4. F-01 disposition answer

A defensible teaching disposition is `accepted` only when the reviewer has
inspected every evidence-chain link, confirms the 22 exclusions and affected
summary values against the benchmark, and records the reason. Otherwise the
reviewer should select `rejected` or `escalated`, identify the missing or
conflicting evidence, and state the remaining coverage needed. The exercise
does not prescribe a clinical acceptability decision.
