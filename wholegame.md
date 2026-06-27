# Whole Game: AI Agents for Clinical Study Workflows

## One-sentence positioning

This book demonstrates an AI-native way to work through selected clinical trial workflows.

This is a **demo, not a prescription**. The book focuses on how clinical teams can work with AI on selected workflows. It intentionally does not cover full compliance implementation, because compliance depends on each company's or organization's infrastructure, policies, validation process, and regulatory obligations.

## Audience

The first audience is:

- clinical statisticians;
- statistical programmers;
- statistical programming leads;
- study reviewers who work with SAP, ADaM, and TLF deliverables.

Readers already understand clinical study work. The book should help them understand how AI agents can support that work without replacing human scientific and programming judgment.

## Simple agent framing

For this book, start simple:

```text
Agent = LLM + Tools
```

The **LLM** reasons, reads, explains, and plans.

**Tools** let the agent inspect real workflow artifacts and take bounded actions. For example, tools may:

- read the SAP;
- inspect ADaM datasets;
- search analysis code;
- parse TLF outputs;
- run consistency checks;
- produce a structured finding log.

Without tools, the LLM mostly talks about pasted text. With tools, the agent can work inside the study workflow and cite evidence from actual files.

Later, we can introduce the fuller operational view:

```text
Agent = LLM + Tools + Harness + Running Environment
```

The **harness** defines prompts, schemas, guardrails, and human checkpoints. The **running environment** contains the study files, code, packages, permissions, and logs.

## Running example

The main worked example is:

> Verify that TLF outputs derived from ADaM datasets follow the Statistical Analysis Plan.

Short form:

```text
SAP -> ADaM -> TLF verification
```

This example is useful because it is familiar, bounded, and high-value for clinical statisticians and programmers.

The workflow connects:

- SAP requirements;
- ADaM datasets and derivations;
- analysis programs;
- generated TLF outputs;
- review findings for human judgment.

The agent should use tools to inspect the artifacts, check consistency against the SAP, and produce an evidence-backed issue log. Human review remains required for clinical and statistical judgment.

## Compliance boundary

In scope for this book:

- AI-native workflow patterns;
- agent concepts for clinical statisticians and programmers;
- tool use inside clinical workflows;
- SAP -> ADaM -> TLF verification as a worked example;
- traceable, evidence-backed findings;
- human review checkpoints.

Out of scope for this book:

- full GxP implementation;
- computer system validation;
- 21 CFR Part 11 or Annex 11 implementation;
- production access control;
- company-specific audit trail infrastructure;
- organization-specific change control.

Those topics are necessary for production use, but they must be handled inside each organization's own infrastructure and quality system.

## Open questions

- Should the worked example use a fully synthetic study or public example data?
- Should examples use R, Python, or both?
- How much implementation detail should the first edition include?
- Should `wholegame.md` stay as a planning file, or should parts of it become chapter stubs?

## Next steps

1. Align on the one-sentence positioning.
2. Draft Chapter 1: AI agents for clinical statisticians and programmers.
3. Draft Chapter 2: tools as part of agents.
4. Draft the worked example: SAP -> ADaM -> TLF verification.
5. Decide the first demo dataset and tool stack.
