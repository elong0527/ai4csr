# Trial notes: chapter-drafting-skill prototype vs freeform review

Subject: the Sampling paragraph for Principle 5 (`03-principle.qmd`,
lines 136-142), chosen because follow-up issue #68 already owns its
evidence gap. Method: first a freeform read-through (without-skill),
then the skill's section-feedback checklist (with-skill) on the same
paragraph. Neither pass edited the manuscript.

Paragraph under review:

```text
**Sampling.** Not every finding needs the same depth of review. Stratify by
risk: deep review for high-severity, novel, or low-confidence findings, and
spot checks for the rest. Record which finding class received which depth
and why, so the split itself is inspectable. TODO: the book states no
measured sampling fractions; each team sets them and records the plan with
the benchmark report (`templates/benchmark-report.md`) and the monitoring
report (`templates/monitoring-report.md`).
```

## Without-skill pass (freeform read-through)

Findings:

- The paragraph reads clearly and the risk-stratification advice is
  concrete (severity, novelty, confidence as strata).
- Suggested adding a worked example of a sampling split to make the
  advice stick.
- Noted the TODO sentence feels unfinished but treated it as an
  ordinary editorial loose end.

Missed: the TODO marker violates the book's own rule against TODO
markers in prose; no check of whether the `templates/` paths exist;
no verdict on whether any claim needs a source or an issue.

## With-skill pass (checklist-driven)

Clarity: no complex sentences; "so the split itself is inspectable"
states the reason for recording, which is good.

Flow: fits the section's one purpose (designing review so the gate
pays for itself); no reorder needed.

Evidence:

- "Deep review for high-severity, novel, or low-confidence findings"
  is a recommendation, not a factual claim; no source required.
- "The book states no measured sampling fractions" is accurate as a
  description of the current manuscript, and its follow-up already
  exists as issue #68. No new issue needed.
- Recommendation (for owner, not applied here): reword the TODO
  sentence so the prose carries no TODO marker, e.g. state that
  teams set and record their own fractions with the benchmark and
  monitoring reports, while #68 tracks the missing measured example
  outside the manuscript.

Voice: principle-level paragraph, no technology-first passage and no
hype; pass.

Rule gate:

- FAIL: `TODO:` marker in book text (AGENTS.md forbids it; #68 is the
  correct home for the follow-up).
- PASS: ASCII-only; no invented facts; no issue-number references in
  prose; no compliance or approval claims.
- PASS: `templates/benchmark-report.md` and
  `templates/monitoring-report.md` both exist in the repo, so the
  paragraph's recording paths are valid.

## With-skill vs without-skill

| Aspect | Without-skill | With-skill |
|---|---|---|
| Prose quality | Same catch (clear, concrete) | Same catch |
| TODO-in-prose violation | Missed (read as loose end) | Caught, with rule citation and fix direction |
| Evidence follow-up | "Add an example" with no home | Pointed at existing issue #68; no duplicate filed |
| Path and ASCII checks | Not performed | Partially performed; one open verification item |
| Invented-citation risk | Present (example suggested without source) | Guardrail refused: no example added without a source |

## Verdict on the prototype

The skill earned its keep on exactly one thing the freeform pass
missed: enforcing the book's own manuscript rules (no TODO in prose,
every gap homed to an issue, no unsourced example). Open before owner
review: trial the outline step on a not-yet-drafted section.
