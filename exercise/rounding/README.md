# Scheduled BR-001 rounding review lab

This lab implements the skill and operating controls designed in the rounding
chapters. It is a reproducible teaching prototype, not a validated or
production-qualified system.

The default commands do not create GitHub issues. Do not enable publishing to a
repository unless its maintainers have authorized the automation identity and
the process owner has accepted the release record.

## What the lab contains

- `.agents/skills/rounding-rule-review/`: the portable Agent Skills package
- `schemas/review-report.schema.json`: structured agent output contract
- `scripts/run_rotation.py`: one-package-per-run rotation and change detection
- `scripts/validate_report.py`: finding admission checks
- `scripts/publish_issue.py`: deterministic package-level issue management
- `fixtures/`: synthetic R sources and an offline target registry
- `expected/`: independently stated expected report
- `targets.json`: the five-package, 30-run pilot registry
- `cron.example`: a scheduler template that is not active in this repository

## Prepare the environment

Use Python 3.10 or later, R 4.1 or later, Git, and GitHub CLI. Install the pinned
comparison package into the R library used by the scheduled identity:

```bash
Rscript -e 'pak::pkg_install("cards@0.9.0")'
```

Run the offline tests:

```bash
python3 -m unittest discover -s tests -v
```

Run the deterministic scanner and tie probe directly:

```bash
Rscript .agents/skills/rounding-rule-review/scripts/scan-rounding-calls.R \
  fixtures/violations/R

Rscript .agents/skills/rounding-rule-review/scripts/probe-tie-behavior.R \
  round 1 -2.05,2.05
```

The probe returns a nonzero status when it observes a BR-001 divergence. That
status is evidence, not a script failure.

## Exercise the controller without an agent or network

Use temporary state and the supplied answer-key report:

```bash
rounding_tmp="$(mktemp -d)"
python3 scripts/run_rotation.py \
  --registry fixtures/targets.json \
  --state "$rounding_tmp/state.json" \
  --runs-dir "$rounding_tmp/runs" \
  --observed-sha aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  --local-target fixtures/violations \
  --report-input expected/violations-report.json
```

Run the same command again with the same state. The second run records
`no-change` and does not repeat the full review.

## Run with Codex

As verified on 2026-09-06, Codex discovers repository skills under
`.agents/skills`, supports explicit `$skill-name` invocation, and provides
`codex exec` for scripts and scheduled jobs. See the official documentation for
[skills](https://learn.chatgpt.com/codex/build-skills) and
[non-interactive mode](https://learn.chatgpt.com/codex/non-interactive-mode).

Test one dry run before installing a schedule:

```bash
python3 scripts/run_rotation.py
```

The controller checks out the selected package at the resolved commit, invokes
Codex in a read-only sandbox, validates the JSON report, and renders the issue
action without executing it. It removes GitHub publishing credentials from the
agent subprocess.

To use another code agent, pass `--agent-adapter /absolute/path/to/adapter`.
The adapter receives three arguments: prompt path, JSON Schema path, and report
output path. It must write one conforming JSON report and exit with status zero.
The adapter must enforce read-only source access and no network access. Run it
in a credential-free operating-system context; the controller removes common
GitHub environment tokens and supplies an empty GitHub CLI configuration, but
it cannot isolate credentials held by every third-party agent product.

## Install a daily schedule

Copy `cron.example`, replace its absolute paths, and install it with the
scheduler owned by the automation identity. The schedule invokes one package
per day in registry order. Five packages over 30 runs give each package six
review opportunities and a maximum scheduled detection delay of five days.

Codex scheduled tasks are another possible harness when they are available in
the reader's ChatGPT workspace. Official documentation states that local
scheduled tasks require the desktop app to remain running and that Codex CLI
does not provide the Scheduled management interface. The external cron example
therefore remains the portable reference for this lab.

## Authorize issue publishing

Before publishing:

1. Replace `SET_PROCESS_OWNER` and `SET_AUTOMATION_LOGIN` in `targets.json`.
2. Authenticate GitHub CLI as that exact automation identity.
3. Grant only repository-content read and issue read/write permissions.
4. Confirm that the five repository maintainers accept automated issue
   creation, updates, comments, and closure.
5. Test the first run without `--publish` and inspect its report and rendered
   issue body.

Then add `--publish` to the scheduled command. The publisher creates at most one
open automation-owned BR-001 issue per package, updates its managed section or
comments when editing is unavailable, and closes it after all verified findings
are addressed. It never changes an issue created by another identity.

## Inspect the 30-run record

The mutable `var/` directory contains rotation state and one directory per run.
Each run records the selected package, exact commit, status, report, agent log,
and issue action. Use these records to produce the monitoring report described
in the chapter.
