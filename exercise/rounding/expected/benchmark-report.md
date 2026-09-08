# BR-001 prototype benchmark report

- Date: 2026-09-08
- Skill: `rounding-rule-review` v1.0.0
- Rule: BR-001 v1.0
- Comparison: `cards::round5()` from `cards` 0.9.0
- Test command: `Rscript exercise/rounding/tests/test-rounding-workflow.R`
- Test environment: R 4.5.3 on x86_64-conda-linux-gnu; Quarto 1.10.18
- Recorded probe environment: R 4.6.1 on arm64 macOS
- Workflow implementation: R 4.1 or later with `jsonlite`
- Target data: synthetic R source under `fixtures/`

## Executed results

| Check | Result |
|---|---|
| Offline R tests | 31 of 31 passed |
| Catalog scan of `fixtures/violations/R` | 1 file, 2 candidates, 0 parse errors |
| Same-line scanner identity | Both `round()` calls retained with distinct columns, token IDs, expressions, and candidate IDs |
| Pinned two-value `round()` probe | 2 of 2 results diverged as expected |
| Pinned four-value `formatC()` probe | 3 divergences, including negative zero |
| Expected report admission | Passed |
| Controller-owned source evidence | False-clean inventory and fabricated finding and unresolved locations rejected |
| Same-commit controller behavior | Second run recorded `no-change` |
| Pre-resolution failure behavior | Failure recorded and rotation advanced |
| Clean no-issue reconciliation | Repeated publish skipped at the same commit |
| Failed closure reconciliation | Same unchanged commit retried and closure completed |
| Human text preservation during managed issue update | Passed |
| Historical closed-issue lookup | Latest owned episode selected |
| Duplicate open-issue handling | Publication stopped |
| Incomplete review handling | Open issue retained and commit scheduled for retry |
| Complete clean-review handling | Open issue closed |
| Built-in Codex path | Disabled because OS isolation is not verified by this repository |
| Cron runtime initialization | Private `var/` directory created before log redirection |
| Quarto resource boundary | Immutable exercise assets copied; runtime `var/` canary excluded |

The recorded probes are stored in `expected/probe-round-digits-1.tsv` and
`expected/probe-formatc-digits-1.tsv`. The schema-conforming answer key and its
structured scanner inventory are stored in `expected/violations-report.json`.

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
