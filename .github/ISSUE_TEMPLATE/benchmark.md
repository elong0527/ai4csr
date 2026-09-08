---
name: Benchmark Evaluation Data
about: Submit a new test case to benchmark a specific AI agent skill or AI-first workflow
title: "[benchmark][skill-name] Short summary of the task"
labels: benchmark, eval
assignees: ''
---

## Scope

<!-- What is being evaluated: one agent skill, or one AI-first workflow stage? Name the governing artifact and its version (task contract, workflow brief) so results stay comparable across runs. -->

## Skills / Workflow

<!-- List the exact skill name(s) this benchmark is designed to test (e.g., group_sequential_design), or the workflow and lifecycle stage under test. -->

## Query

<!-- Provide the exact, realistic prompt the user would type to trigger and test this skill. Feel free to use casual language, typos, or specific jargon. -->

## Case type

<!-- ordinary | boundary | negative | missing-context | no-finding. Every benchmark needs at least one missing-context or unsupported-finding case and one no-finding case with a coverage requirement. -->

## Evaluator type

<!-- deterministic suite | model judge | human review | mixed. State who or what grades the output, independently of the implementation. -->

## Expected Output

<!-- Provide a human-readable description of what a successful output looks like. Expected results must be stated independently of the implementation under test. -->

## Metrics and denominators

<!-- Predefined metrics with denominators, e.g. detection rate = detected seeded defects / total seeded defects; false-positive count; coverage = rules checked / rules in scope. Label any unavailable measurement instead of omitting it. -->

## Acceptance threshold

<!-- The numeric bar for accept / revise / reject, agreed before results are observed. -->

## Attached Files / Input Context (Optional)

<!-- If this query relies on an input file (e.g., ADSL.csv, protocol.pdf), please describe the file content here or attach a link to it so the benchmark can be properly reproduced. -->

## Coverage and limits

<!-- What the benchmark checks and what it does not cover; component versions that bound the result. -->

## Rubric Criteria (Optional)

<!-- List testable, objective assertions that can be used to automatically grade the agent's output. Provide one assertion per line starting with a dash.
Example:
- The output must include a Markdown table.
- The script must use the `gsDesign` R package.
- The output file must be valid JSON.
-->
