# Scheduled BR-001 rounding review lab

This lab implements the skill and operating controls designed in the rounding
chapters. It is a reproducible teaching prototype, not a validated or
production-qualified system.

The default commands do not create GitHub issues. Do not enable publishing to a
repository unless its maintainers have authorized the automation identity, the
process owner has accepted the release record, and that process owner has
separately accepted the current run's classification and issue action.

## What the lab contains

- `.agents/skills/rounding-rule-review/`: the portable Agent Skills package
- `schemas/review-report.schema.json`: structured agent output contract
- `scripts/run-rotation.R`: one-package-per-run rotation and change detection
- `scripts/validate-report.R`: finding admission checks
- `scripts/publish-issue.R`: deterministic package-level issue management
- `scripts/rounding-workflow.R`: shared implementation used by those commands
- `fixtures/`: synthetic R sources and an offline target registry
- `expected/`: independently stated expected report
- `targets.json`: the five-package, 30-run pilot registry
- `cron.example`: a scheduler template that is not active in this repository

## Prepare the environment

Use R 4.1 or later, Git, and GitHub CLI. Install `jsonlite` and the pinned
comparison package into the R library used by the scheduled identity:

```bash
Rscript -e 'install.packages("jsonlite", repos = "https://cloud.r-project.org")'
Rscript -e 'pak::pkg_install("cards@0.9.0")'
```

Run the offline tests:

```bash
Rscript tests/test-rounding-workflow.R
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
Rscript scripts/run-rotation.R \
  --registry fixtures/targets.json \
  --state "$rounding_tmp/state.json" \
  --runs-dir "$rounding_tmp/runs" \
  --observed-sha aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  --local-target fixtures/violations \
  --report-input expected/violations-report.json
```

Run the same command again with the same state. The second run records
`no-change` and does not repeat the full review.

## Run with an independently isolated agent adapter

The built-in Codex adapter is disabled. This repository does not verify that a
normal user-level Codex configuration provides the credential-free
operating-system boundary required for reviewing untrusted source. A run
without `--report-input` or `--agent-adapter` therefore fails closed.

An external adapter receives three arguments: prompt path, JSON Schema path,
and report output path. It must write one conforming JSON report and exit with
status zero. Run it in a separately verified environment with only the target
checkout and immutable skill inputs readable and with credentials, unrelated
host files, network, web, MCP, app, and connector access unavailable. The
controller's removal of common GitHub environment tokens is defense in depth,
not an isolation boundary.

Test one dry run with that adapter before installing a schedule:

```bash
Rscript scripts/run-rotation.R \
  --agent-adapter /absolute/path/to/isolated-adapter
```

The controller checks out the selected package at the resolved commit, records
its own structured scan, invokes the adapter, validates the JSON report against
the scan and source, and renders the issue action without executing it.

## Install a daily schedule

Copy `cron.example`, replace its absolute paths, and install it with the
scheduler owned by the automation identity. Each invocation creates the
private runtime directory before opening the log, then invokes one package per
day in registry order through the approved adapter. Five packages over 30 runs
give each package six review opportunities and a maximum scheduled detection
delay of five days.

Codex scheduled tasks are another possible harness when they are available in
the reader's ChatGPT workspace. Official documentation states that local
scheduled tasks require the desktop app to remain running and that Codex CLI
does not provide the Scheduled management interface. The external cron example
therefore remains the portable reference for this lab.

## Authorize issue publishing

Before the pilot and before publishing:

1. Replace `SET_PROCESS_OWNER` and `SET_AUTOMATION_LOGIN` in `targets.json`.
2. Authenticate GitHub CLI as that exact automation identity.
3. Grant only repository-content read and issue read/write permissions.
4. Confirm that the five repository maintainers accept automated issue
   creation, updates, comments, and closure.
5. Test the first run without `--publish` and inspect its scanner evidence,
   report, and rendered issue body.

Do not add `--publish` to the unattended cron entry. For each completed run,
the process owner classifies the result and separately accepts or rejects its
issue action. The `--publish` flag requires a pre-reviewed report, and the
publisher rechecks the report against a clean source checkout at the report's
exact commit before acting. It creates at most one open automation-owned
BR-001 issue per package, updates its managed section or comments when editing
is unavailable, and closes it after all verified findings are addressed. It
never changes an issue created by another identity.

## Inspect the 30-run record

The mutable `var/` directory contains rotation state and one directory per run.
Each run records the selected package, exact commit, status, deterministic scan,
report, agent log, and issue action. Quarto excludes this directory from the
published book while copying the immutable exercise assets. Use the local
records to produce the monitoring report described in the chapter.
