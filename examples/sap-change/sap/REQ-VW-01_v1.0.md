# SAP excerpt: visit-window rule (baseline)

Requirement ID: REQ-VW-01
Version: v1.0
Status: accepted

## Rule

The Week 24 primary efficacy assessment must fall within the visit window
to count toward the per-protocol population.

Window: +/- 3 days around the target visit day (Day 168).

## Per-protocol definition (excerpt)

A randomized subject belongs to the per-protocol population when all of
the following hold:

1. The subject received the assigned treatment.
2. The Week 24 assessment date is within the visit window above.
3. No major protocol deviation affecting efficacy was recorded.

## Traceability

- Code symbol: derive_pp_flag
- Data field: PPFL (Y/N)
- Table: disposition, per-protocol rows
