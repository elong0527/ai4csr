# BR-001 prototype benchmark report

- Date: 2026-09-06
- Skill: `rounding-rule-review` v1.0.0
- Rule: BR-001 v1.0
- Comparison: `cards::round5()` from `cards` 0.9.0
- R environment: R 4.6.1 on arm64 macOS
- Workflow implementation: R 4.1 or later with `jsonlite`
- Target data: synthetic R source under `fixtures/`

## Executed results

| Check | Result |
|---|---|
| Agent Skills structure validation | Passed |
| Offline R tests | 14 of 14 passed |
| Catalog scan of `fixtures/violations/R` | 1 file, 2 candidates, 0 parse errors |
| Pinned two-value `round()` probe | 2 of 2 results diverged as expected |
| Pinned four-value `formatC()` probe | 3 divergences, including negative zero |
| Expected report admission | Passed |
| Same-commit controller behavior | Second run recorded `no-change` |
| Human text preservation during managed issue update | Passed |
| Historical closed-issue lookup | Latest owned episode selected |
| Duplicate open-issue handling | Publication stopped |
| Incomplete review handling | Open issue retained and commit scheduled for retry |
| Complete clean-review handling | Open issue closed |

The executed probes are stored in `expected/probe-round-digits-1.tsv` and
`expected/probe-formatc-digits-1.tsv`. The schema-conforming answer key is
stored in `expected/violations-report.json`.

## Not yet measured

- implicit skill selection across code-agent products;
- live-agent detection of the uncataloged wrapper fixture;
- comparative performance of the one-file and resource-backed versions;
- reproduction of every pinned `metalite.ae` answer-key location;
- GitHub create, edit, comment, and close operations against live repositories;
- the five-package, 30-run operating campaign; and
- false-positive, latency, cost, and maintainer-burden measures from operation.

## Disposition

The deterministic foundation is reproducible and supports prototype maturity.
The Test gate for a live release remains open. An independent reviewer and the
process owner must accept the remaining agent and integration evidence before
the scheduled identity is allowed to publish issues.
