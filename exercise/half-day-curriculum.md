# Half-day Biometrics leader workshop: proposed curriculum

Status: proposed draft. Operational details (delivery
deadline, class size, participant platform, account budget, facilitator
staffing) stay open; they do not block this draft.

## Design constraints (confirmed)

- Audience: Biometrics leaders with little coding experience. The book
  keeps its wider Biometrics audience.
- Duration: half a day, approximately three to four hours.
- Each participant leaves with a workflow brief, a task contract, and an
  evaluation of a prepared prototype, completed as one coherent set for
  the anchor scenario (rounding by default; see the agenda).
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

## Proposed agenda (about 2.5 hours)

| Minutes | Activity |
|---|---|
| 15 | Welcome, objectives, the three take-home artifacts, and anchor-scenario choice. |
| 25 | Slot 1 guided exercise: bound the study-design request, draft a practice brief. |
| 10 | Break. |
| 40 | Slot 2 guided exercise: state the rounding rule, write the rounding brief, complete the task contract, run the check, judge the findings. |
| 35 | Slot 3 guided exercise: trace one SAP change, check coverage, record open decisions. |
| 20 | Read-out: each table assembles its anchor-scenario set and defends one accountable decision; facilitator scores decisions, not coding speed. |
| 10 | Close: what transfers to Monday work, and what stays a human approval. |

Total: 155 minutes (about 2 hours 35 minutes), leaving a 25-minute
buffer inside a three-hour booking and a larger buffer inside the
half-day window.

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
