# SAP excerpt: Week 24 analysis-window rule (baseline)

Requirement ID: REQ-WIN-01
Version: v1.0
Status: accepted
Source: CDISCPILOT01 final SAP, Section 8.2 (Assessment Windows),
as appended to the clinical study report (RConsortium/submissions-pilot1,
adam/cdiscpilot_docs/cdiscpilot01.pdf). Paraphrased; the window table values
below are transcribed verbatim.

## Rule

Assessments are assigned to visits based on actual visit dates relative to
randomization. If multiple assessments fall into the same visit window, the
assessment closest to the target day is selected. If two assessments are
equidistant from the target day, the assessment prior to the target day is
selected. Retrieval visits are included for selecting the Week 24 window.

Week 24 window for ADAS-Cog (11), CIBIC+, and NPI-X: assessments after
Day 140, target Day 168. There is no upper bound.

## Machine-readable parameters

WindowLower: 141
WindowUpper: none
WindowTarget: 168

## Traceability

- SAP rule: Section 8.2, Week 24 row
- Data columns: ADY, AWTARGET, AWLO, AWHI
- Selection flag: ANL01FL (Week 24 record selected for analysis)
- Code symbol: select_week24
- Table: CSR Table 14-3.01 (ADAS-Cog change baseline to Week 24, LOCF)
- Program: submissions-pilot1 vignettes/tlf-primary.Rmd, Step 2 filter
