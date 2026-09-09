# SAP excerpt: Week 24 analysis-window rule (amended)

Requirement ID: REQ-WIN-01
Version: v1.1
Status: accepted
Supersedes: v1.0

> CONSTRUCTED TEACHING AMENDMENT. This amendment is invented for the book
> example. It is not part of the real CDISCPILOT01 SAP and must never be
> presented as a real protocol change.

## Rule

Unchanged from v1.0 except: the Week 24 window is capped at Day 182
(Week 26 nominal). Assessments after Day 182 are excluded from the
Week 24 summary and listed. The selection method (closest to target,
ties to the earlier assessment) is unchanged.

## Change note

Late off-schedule assessments (up to Day 286 in the pilot data) enter the
unbounded Week 24 window. Capping the window keeps the analysis near the
target visit; excluded subjects appear in the listing, with a sensitivity
analysis planned, not executed.

## Machine-readable parameters

WindowLower: 141
WindowUpper: 182
WindowTarget: 168

## Traceability

Same chain as v1.0. Expected effect: 22 subjects leave the Week 24
summary, concentrated in the xanomeline low dose arm.
