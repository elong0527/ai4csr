# Benchmark report: <short title>

> Success criteria are fixed before results are observed. Separate
> deterministic checks from model judgment for every finding. Report learner
> assessment separately from prototype performance.

- Artifact version: 0.1 (draft)
- Status: draft | accepted | superseded
- Workflow: <same name as the workflow brief>
- Prototype version: <version of the evaluated prototype>
- Governing task contract version: <version>
- Independent expected results version: <version; stated independently of the implementation>
- Authors: <Biometrics owner; AI engineer>
- Evaluator type: <deterministic suite | model judge | human review | mixed>
- Date: <YYYY-MM-DD>

## Biometrics decision required

<The decision this report asks for: return to Plan, Design, or Build; reject
the candidate; or accept it for a controlled release.>

## Benchmark dataset and cases

<Dataset, cases, and independently stated expected results. Include ordinary,
boundary, negative, missing-context, and no-finding cases.>

## Workflow, model, and dependency versions

<Exact versions of the workflow, model, instructions, tools, and dependencies
used in the run.>

## Predefined metrics and acceptance thresholds

<Metrics with denominators fixed before the run; the threshold for each.
Name abstention and trace-completeness metrics explicitly alongside
accuracy-style metrics:

- Abstention: correct abstentions / cases where the evidence was genuinely
  ambiguous or the required context was missing. A confident fabrication on
  such a case is a failure, not a neutral miss.
- Claim-to-evidence trace completeness: factual claims in the output carrying
  a valid citation to an artifact that states what is claimed / total factual
  claims in the output.>

## Results

<Per-case results. For detection-style cases report: true positives, false
positives, missed findings (false negatives), and coverage with denominators.
Report abstentions separately from misses: a case the agent correctly declined
to decide is not a false negative. For every finding, report the
trace-completeness check: claims with valid artifact citations versus total
factual claims. Label any measurement that was unavailable instead of omitting
it.>

## Failure analysis

<False positives, missed findings, unsupported claims, escalation quality, and
what each failure implies for the design.>

## Coverage, reproducibility, latency, and cost

<Coverage of rules and files; repeat-run stability; time and cost when
relevant. Silence is not evidence.>

## Limitations and recommended disposition

<Residual uncertainty, limits of the benchmark, and the recommended next step.>

## Engineering contribution

<Controlled evaluation setup, preserved versions and settings, investigated
technical failure modes.>

## Evidence attached

<Raw outputs, logs, and the exact run command; state coverage and gaps.>

## Accountable human gate

- Gate: accept, revise, or reject the candidate.
- Owner: <named role>
- Decision: <pending | accepted for controlled release | revise | reject> on <date>

## Next-stage event

<An accepted candidate initiates Deploy. An agent does not approve its own
benchmark.>
