# Half-day Biometrics leader workshop: proposed curriculum

Status: proposed draft for issue #10. Operational details (delivery
deadline, class size, participant platform, account budget, facilitator
staffing) stay open and are tracked in #10; they do not block this draft.

## Design constraints (confirmed in #10)

- Audience: Biometrics leaders with little coding experience. The book
  keeps its wider Biometrics audience.
- Duration: half a day, approximately three to four hours.
- Each participant leaves with a workflow brief, a task contract, and an
  evaluation of a prepared prototype.
- Participants use a browser-based AI agent, with a recorded fallback so
  that accounts or setup problems do not block participation.
- Prepared code and data are supplied so that unfamiliarity with R or Git
  does not prevent participation.
- The workshop samples the examples in an instructional sequence without
  renumbering the book. The code-review survey and YAMAA chapters are not
  prerequisites for the first workshop.

## Scenario slots and teaching purposes

| Slot | Purpose | Book source |
|---|---|---|
| 1. Study design | Turn an unbounded request into a testable workflow. | `study-design.qmd` |
| 2. Rounding | Translate business rules into checks and evaluate findings. | `06-workflow-rounding.qmd`, `07-workflow-rounding-skill.qmd`, `08-workflow-rounding-lab.qmd` |
| 3. SAP change review | Trace an accepted requirement change through code and results, including coverage and unresolved decisions. | `09-workflow-sap-change.qmd` |

The warm-up pattern for slot 2 is the existing day-1 exercise
(`exercise/day1/README.md`), in which participants specify work, inspect
evidence, and make an accountable decision about a prepared synthetic
dataset.

## Proposed agenda (about 3.5 hours)

| Minutes | Activity |
|---|---|
| 20 | Welcome, objectives, and the three artifacts (brief, contract, evaluation). |
| 30 | Slot 1 guided exercise: bound the study-design request, write the workflow brief. |
| 15 | Break. |
| 45 | Slot 2 guided exercise: state the rounding rule, run the check, judge the findings. |
| 45 | Slot 3 guided exercise: trace one SAP change, check coverage, record open decisions. |
| 30 | Read-out: each table defends one accountable decision; facilitator scores decisions, not coding speed. |
| 15 | Close: what transfers to Monday work, and what stays a human approval. |

Total: 200 minutes (3 hours 20 minutes), leaving a 10 to 40 minute
buffer inside the half-day window.

## Participant forms (follow the book, one page each)

- Workflow brief form: objective, inputs, scope, outputs, boundaries, escalation conditions.
- Task contract form: the agent's role, the accountable human, acceptance criteria.
- Evaluation form: finding, evidence, decision (accept / escalate), approver, date.

Completed examples for each form are supplied from the chapters listed
above. A plain-language scoring guide rewards correct accountable
decisions over coding speed.

## Rehearsal and readiness

- One full rehearsal with the recorded fallback, timed against this agenda.
- Readiness check before scheduling: prepared code and data run end to end,
  forms print on one page each, and the fallback recording covers every
  hands-on step.

Refs #10.
