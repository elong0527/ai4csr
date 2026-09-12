---
name: chapter-drafting-skill
description: Drafts ai4csr book chapters section by section with outline feedback, citation checks, and voice passes that enforce AGENTS.md rules. Use when drafting or revising a chapter (.qmd) of the AI-first clinical study reporting book.
---

# Chapter Drafting Skill (prototype)

A writing partner for ai4csr chapters. It adapts the section-by-section
feedback, citation management, and voice-preservation pattern of
`content-research-writer`
(ComposioHQ/awesome-claude-skills, pinned at `be2a406`, retrieved
2026-09-12; guardrail-vs-workflow framing per
`https://bgpopescu.net/teaching/agentic/lecture4.html`) to the rules in
`AGENTS.md`: the six-stage AI-first SDLC, maturity labels, ASCII-only
sources, Biometrics voice, and no invented citations.

Status: prototype for owner review. It changes no manuscript file; trial
record is in `trial-notes.md`.

## When to Use This Skill

- Drafting a new chapter section from an outline.
- Revising a chapter section against reviewer or benchmark evidence.
- Checking a section's citations, voice, and AGENTS.md compliance.
- Deciding whether a claim needs a source, a TODO issue, or deletion.

## What This Skill Does

1. **Chapter outlining**: maps the chapter's teaching purpose onto sections
   before any prose is written.
2. **Section feedback**: reviews one section at a time for clarity, flow,
   evidence, and voice.
3. **Citation check**: verifies every factual claim has a source or a
   follow-up GitHub issue; never invents one.
4. **Voice pass**: keeps Biometrics-first, plain, direct prose and the
   clinical-story-before-technology order.
5. **Rule gate**: rejects output that violates AGENTS.md (non-ASCII,
   TODO markers or issue-number references in book text, hype, invented
   facts, unpinned time-sensitive references).

## How to Use

### 1. Start from the chapter's teaching purpose

State one primary teaching purpose and the chapter's place in the book's
argument before outlining. One chapter teaches one thing; a second
purpose is a second chapter (or a follow-up issue).

Ask:

- What is the single lesson the reader must retain?
- Which lifecycle stages and canonical artifacts does this chapter use?
- What is the declared maturity level, and what evidence supports it?
- Which adjacent chapters must be checked for overlap first?

### 2. Outline against the lifecycle

```markdown
# Chapter outline: [Title]

## Teaching purpose (one sentence)

## Boundary and non-goals

## Maturity level and supporting evidence

## Sections

### Section 1: [Title]
- Key point A
- Key point B
- Example or evidence (real, synthetic, or constructed -- label which)
- [Evidence needed: specific claim or measurement]

## Cross-references to check (adjacent chapters)

## Research to-do (each item becomes a GitHub issue, never a TODO in prose)
- [ ] Source for [claim]
- [ ] Measured example for [paragraph]
```

### 3. Draft one section, then request feedback

Write one section at a time and ask for feedback before moving on:

```markdown
I just finished the "[Section Name]" section of [chapter]. Review it
against the skill's section-feedback checklist.
```

### 4. Run the citation check

For every factual claim in the section, the skill reports one of:

- Sourced (with the source and, for time-sensitive product behavior,
  a retrieval date or pinned commit).
- Follow-up issue filed (with the issue number recorded outside the
  manuscript, never as a TODO in book text).
- Deleted or reworded because no source exists and no issue is warranted.

Unsupported claims are never left standing and never papered over with
a plausible-looking citation.

### 5. Run the voice pass

- Biometrics professional first: team role, assignment, protocol, SAP,
  data, and review question before technology.
- Plain, direct language; AI or software terms defined on first use.
- Objective prose for requirements and conclusions; direct address only
  inside brief scenarios or exercises.
- No hype, no vendor marketing language, no unsupported claims.

## Section-feedback checklist

```markdown
# Feedback: [Section Name]

## What works
- [Strength 1]
- [Strength 2]

## Clarity
- [Complex sentence] -> [Simpler alternative]

## Flow
- [Transition issue] -> [Better connection to the chapter's one purpose]

## Evidence
- [Claim needing support] -> [Add source, file follow-up issue, or delete]
- [Synthetic or constructed material] -> [Label it; never imply it is
  submission-ready or real participant data]

## Voice
- [Technology-first passage] -> [Clinical story first]
- [Hype or marketing phrase] -> [Plain statement]

## Rule gate (AGENTS.md)
- [ ] ASCII-only source (no smart quotes, dashes, or symbols)
- [ ] No TODO markers or issue-number references in book text
- [ ] No invented facts, quotations, results, or references
- [ ] Time-sensitive references pinned or dated
- [ ] One teaching purpose; overlap with adjacent chapters checked

## Questions to consider
- [Question 1]
- [Question 2]
```

## Guardrails (what the skill refuses)

Borrowing the guardrail-vs-workflow distinction: the outline, feedback,
and checklists above are the workflow; the refusals below are
guardrails that hold even when asked to skip them.

- Will not invent a citation, measurement, quotation, or reference.
- Will not leave a TODO marker or issue number in book text.
- Will not introduce non-ASCII characters into sources.
- Will not present constructed teaching amendments as real protocol
  changes, or synthetic data as submission-ready.
- Will not claim compliance, validation, or GxP approval for any book
  content, model, vendor, or workflow.

## File organization

```text
examples/chapter-drafting-skill/
  SKILL.md          # This file
  trial-notes.md    # With-skill vs without-skill trial record
```

Drafts live outside the manuscript until the owner accepts them; the
skill never edits a `.qmd` file itself.
