# Source and evidence manifest

Review record for issue #19. This file is intentionally kept outside the
rendered book so the review process does not become reader-facing narrative
or add a new build dependency. A later publication decision can promote it
to an appendix.

This is a review record, not a replacement for citations:

- keep inline links for inspectable web pages, releases, pinned source
  lines, and product documentation;
- use `references.bib` for conventional publications or repeatedly cited
  sources;
- let each manifest row point to the existing inline link or BibTeX key
  rather than duplicating citation text.

## Field definitions

Each row carries one claim/source relationship. Use multiple rows when one
claim depends on multiple sources.

- **ID:** stable claim identifier (SRC-NNN, never reused).
- **Location:** chapter file and heading or anchor where the claim appears.
- **Claim:** concise teaching assertion as stated in the manuscript.
- **Type:** external fact, vendor-documented behavior, observed result,
  teaching assumption, or regulatory statement.
- **Source and locator:** primary source or artifact with the exact evidence
  locator (section, page, pinned lines, release, commit, or run record).
- **Dates:** source publication or version date when available, plus the
  inspection date in ISO format.
- **Status:** verified, attributed, observed, TODO, or
  qualified-review-required (see vocabulary below).
- **Reviewer and disposition:** responsible reviewer, or explicit
  `unassigned`; limitations that bound how the claim may be used.

## Status vocabulary

- **verified:** the locator was inspected and confirms the claim as stated.
- **attributed:** the source is real and reachable at the recorded locator,
  but the exact wording or value was not confirmed line-by-line.
- **observed:** the artifact or run output exists in this repository or in a
  linked record; provenance rests on the stated construction or capture.
- **TODO:** the claim currently has no confirmed source or locator.
- **qualified-review-required:** a regulatory or safety-adjacent claim that
  needs an identified reviewer to record disposition before publication.

Unsupported claims stay visible TODOs. No source is inferred to fill a gap.

## Seed rows: highest-risk and most central claims

Seeded 2026-09-09. Link reachability was checked with HTTP requests on that
date (200 = reachable); page wording was confirmed only where noted.

### SRC-001: Anthropic lifecycle attribution

- Location: `05-ai-first-sdlc.qmd`, background section citing the six-stage
  lifecycle, committed artifacts, continuous evaluation, and human gates.
- Claim: the book's AI-first SDLC adapts Anthropic's AI-Native SDLC
  Playbook and its lifecycle-security perspective.
- Type: external fact.
- Source and locator:
  `https://academy.claude.com/courses/ai-native-sdlc-playbook/introduction`
  (course landing page) and
  `https://claude.com/blog/how-anthropic-secures-its-ai-native-software-development-lifecycle`
  (security article). Both returned HTTP 200 on 2026-09-09.
- Dates: source version date undated on landing pages; inspected
  2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: confirms the sources
  exist and are reachable, not that every adapted element matches the
  current course text, which the vendor can update.

### SRC-002: FDA warning-letter callout

- Location: `02-ai-first.qmd`, callout "AI output is not regulatory
  clearance".
- Claim: an April 2026 FDA warning letter to Purolea Cosmetics Lab described
  a drug manufacturer that used AI agents to create specifications,
  procedures, and production records without adequate review for accuracy
  and CGMP compliance.
- Type: external fact; the transfer lesson ("AI-generated content remains a
  draft until an authorized person verifies and approves it") is a
  regulatory statement.
- Source and locator:
  `https://www.fda.gov/inspections-compliance-enforcement-and-criminal-investigations/warning-letters/purolea-cosmetics-lab-722591-04022026`.
  Page title confirmed 2026-09-09 as
  "Purolea Cosmetics Lab - 722591 - 04/02/2026 | FDA" (HTTP 200).
- Dates: letter dated 04/02/2026; inspected 2026-09-09.
- Status: qualified-review-required.
- Reviewer and disposition: unassigned. Limitation: existence and date are
  confirmed; the letter's full findings and the stated transfer boundary
  (manufacturing/CGMP, not clinical study reporting) need an identified
  reviewer before publication.

### SRC-003: KEYNOTE-189 public protocol as teaching context

- Location: `04-ai-agent.qmd`, assignment table and exercise prompt.
- Claim: the ClinicalTrials.gov record for KEYNOTE-189 records a minimum age
  of 18 years. The public protocol PDF is the reader-facing teaching context
  used with the synthetic CSV.
- Type: external fact (minimum age) and teaching assumption (use of the PDF
  as context).
- Source and locator: ClinicalTrials.gov API study record,
  `https://clinicaltrials.gov/api/v2/studies/NCT02578680`,
  `protocolSection.eligibilityModule.minimumAge` = `18 Years`, inspected
  2026-09-09. The public protocol PDF remains the reader-facing teaching
  context at
  `https://cdn.clinicaltrials.gov/large-docs/80/NCT02578680/Prot_SAP_001.pdf`.
- Dates: registry record current as inspected 2026-09-09; protocol version
  date not recorded.
- Status: verified.
- Reviewer and disposition: unassigned. Limitation: the API confirms the
  minimum age; any additional population definition used in the exercise
  needs a separately pinned protocol or registry locator.

### SRC-004: R `round()` ties to even

- Location: `06-workflow-rounding.qmd`, cross-language tie table
  (R `round()` half to even; 2.5 becomes 2).
- Claim: base R `round()` rounds halfway cases to even.
- Type: external fact.
- Source and locator: R documentation,
  `https://stat.ethz.ch/R-manual/R-devel/library/base/html/Round.html`
  (HTTP 200 on 2026-09-09).
- Dates: R-devel rolling manual; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: locator reachable; exact
  standard wording not quoted in this row.

### SRC-005: Python `round()` ties to even

- Location: `06-workflow-rounding.qmd`, cross-language tie table
  (Python `round()` half to even; 2.5 becomes 2).
- Claim: Python 3 `round()` uses round-half-to-even for halfway cases.
- Type: external fact.
- Source and locator: Python documentation,
  `https://docs.python.org/3/library/functions.html#round`
  (HTTP 200 on 2026-09-09).
- Dates: Python 3 rolling documentation; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: locator reachable; exact
  standard wording not quoted in this row.

### SRC-006: SAS `ROUND()` half away from zero

- Location: `06-workflow-rounding.qmd`, cross-language tie table
  (SAS `ROUND()` half away from zero; 2.5 becomes 3).
- Claim: SAS `ROUND()` rounds halfway cases away from zero.
- Type: external fact.
- Source and locator: TODO. No SAS documentation locator has been
  confirmed; a guessed documentation URL returned HTTP 404 during seeding
  and is deliberately not recorded here.
- Dates: inspected 2026-09-09 (locator still missing).
- Status: TODO.
- Reviewer and disposition: unassigned. Find the canonical SAS `ROUND`
  function page and pin its tie-breaking statement before publication.

### SRC-007: metalite.ae v0.1.4 pin and commit

- Location: `06-workflow-rounding.qmd` and
  `07-workflow-rounding-skill.qmd`, pinned release and quoted file/line
  results.
- Claim: every reader-facing prompt and quoted result pins metalite.ae
  v0.1.4 at commit `bdb23d472b16bc9dadbc774e64c5ca40321e9c6b`.
- Type: observed result.
- Source and locator:
  `https://github.com/Merck/metalite.ae/releases/tag/v0.1.4` and
  `https://github.com/Merck/metalite.ae/tree/bdb23d472b16bc9dadbc774e64c5ca40321e9c6b`.
  Both returned HTTP 200 on 2026-09-09.
- Dates: release tagged v0.1.4; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: the release and pinned
  commit resolve, but this row does not verify the universal manuscript claim
  or every quoted line number. Any pin change must re-verify all quoted lines
  and probe results in the same change.

### SRC-008: Issue #249 as Arena.ai response example

- Location: `06-workflow-rounding.qmd` and
  `07-workflow-rounding-skill.qmd`, "Try it yourself" and answer-key
  discussion.
- Claim: one Arena.ai response was manually copied to
  Merck/metalite.ae issue #249 by a person; it is an optional example, not
  an answer key, release evidence, or maintainer-approved finding.
- Type: observed result.
- Source and locator: `https://github.com/Merck/metalite.ae/issues/249`
  (HTTP 200 on 2026-09-09).
- Dates: issue as posted; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: reachability confirmed;
  the "posted by a person, not Arena.ai" provenance rests on author
  knowledge, not on a check recorded in this row.

### SRC-009: arena.ai endpoint and teaching limitation

- Location: `04-ai-agent.qmd` and "Try it yourself" sections.
- Claim: prompts direct readers to `https://arena.ai/agent`; no specific
  agent response is an expected result.
- Type: vendor-documented behavior (endpoint) and teaching assumption
  (no answer key).
- Source and locator: `https://arena.ai/agent` returned HTTP 200 on
  2026-09-09. No dated first-party documentation has been recorded for
  current product behavior.
- Dates: inspected 2026-09-09; source publication date TODO.
- Status: TODO.
- Reviewer and disposition: unassigned. Limitation: endpoint reachability is
  not evidence of supported tools, model identity, or run-to-run behavior.
  Capture dated first-party documentation or an observed, versioned run before
  making a time-sensitive product-behavior claim.

### SRC-010: Agent Skills specification layout

- Location: `07-workflow-rounding-skill.qmd`, skill layout section
  (required `SKILL.md` with `name` and `description` frontmatter; optional
  `scripts/`, `references/`, `assets/`; name matches directory).
- Claim: the described layout follows the Agent Skills specification.
- Type: teaching assumption against an external specification.
- Source and locator: `https://agentskills.io/specification`
  (HTTP 200 on 2026-09-09).
- Dates: specification as published; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: section-by-section
  conformance of the chapter's layout to the specification is not recorded
  in this row.

### SRC-011: Codex skill documentation

- Location: `07-workflow-rounding-skill.qmd`, "Start with one instruction
  file" and progressive-disclosure discussion.
- Claim: the official Codex skill documentation states that a skill can be
  one directory containing `SKILL.md`, with `name` and `description`
  frontmatter and optional scripts, references, and assets.
- Type: vendor-documented behavior.
- Source and locator: `https://learn.chatgpt.com/docs/build-skills`
  (HTTP 200 on 2026-09-09).
- Dates: vendor documentation as published; inspected 2026-09-09.
- Status: attributed.
- Reviewer and disposition: unassigned. Limitation: locator reachable; the
  quoted statements are not pinned to dated sections in this row, and
  vendor pages change.

### SRC-012: R Consortium pharma-skills rounding example

- Location: `07-workflow-rounding-skill.qmd`, "Design the maintainable
  target" section.
- Claim: at the pinned commit, the R Consortium example separates the
  broader rounding workflow into `SKILL.md`, `references/`, `scripts/`,
  `assets/`, and `evals/`.
- Type: observed result.
- Source and locator:
  `https://github.com/RConsortium/pharma-skills/tree/544aa0818208a973e6e22901118c8f97b758c146/rounding`
  (HTTP 200 on 2026-09-09).
- Dates: commit `544aa0818208a973e6e22901118c8f97b758c146`; inspected
  2026-09-09.
- Status: verified (pinned tree exists as cited).
- Reviewer and disposition: unassigned. Limitation: confirms the tree
  resolves, not the full file listing quoted in the chapter.

### SRC-013: YAMAA reference implementation (pending chapter)

- Location: future YAMAA chapter for issue #18; background reference only.
- Claim: TODO. No YAMAA chapter content exists yet, so there are no
  chapter claims to evidence. The maintained project is reachable at
  `https://github.com/elong0527/yamaa` (HTTP 200 on 2026-09-09).
- Type: external fact (placeholder).
- Source and locator: TODO; pin versioned implementation evidence when the
  chapter is drafted.
- Dates: inspected 2026-09-09 (repository reachability only).
- Status: TODO.
- Reviewer and disposition: unassigned.

### SRC-014: Dated vendor behavior for the code-review survey (pending)

- Location: future comparative survey for issue #17; no survey content
  exists yet.
- Claim: TODO. No dated product-behavior claims exist to evidence.
- Type: vendor-documented behavior (placeholder).
- Source and locator: TODO; use current first-party documentation with
  dates when the survey is built.
- Dates: none yet.
- Status: TODO.
- Reviewer and disposition: unassigned.

### SRC-015: Synthetic KEYNOTE-189 CSV contains no real records

- Location: `04-ai-agent.qmd`, callout "Synthetic teaching data: not
  KEYNOTE-189 trial data".
- Claim: the CSV has no real KEYNOTE-189 participant records and cannot
  support conclusions about the actual study.
- Type: teaching assumption.
- Source and locator: observed result, repository artifact
  `exercise/day1/kn189-synthetic-adsl.csv` (present in the working tree on
  2026-09-09).
- Dates: artifact as committed; inspected 2026-09-09.
- Status: observed.
- Reviewer and disposition: unassigned. Limitation: provenance rests on
  author construction of the synthetic file; no independent audit of file
  contents is recorded in this row.

## Incremental workflow

1. Seed the highest-risk and most central claims first (done above for the
   lifecycle attribution, the FDA callout, KEYNOTE-189 protocol
   requirements, rounding behavior, dated vendor behavior placeholders, and
   pinned YAMAA evidence placeholder).
2. Each content PR adds or updates rows for substantive claims it changes.
3. The weekly industry scout records material new evidence on the
   responsible issue; a manuscript PR moves accepted evidence into this
   manifest.
4. Before publication readiness, sweep every chapter, reconcile inline links
   and BibTeX keys, check links, record permissions and provenance, and
   obtain the qualified review required for SRC-002.

## Open TODOs from seeding

- SRC-006: confirm the canonical SAS `ROUND` documentation locator.
- SRC-003: pin the exact protocol sections behind the age requirements.
- SRC-002: identify the qualified reviewer and record disposition.
- SRC-013, SRC-014: seed rows when issues #17 and #18 produce content.
