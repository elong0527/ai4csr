# Whole Game: AI for Clinical Study Workflows

This document is the working game plan for evolving **AI for Clinical Study Reports and Submission** toward a practical book on AI agents for clinical study workflows.

## 1. Book focus

The book introduces how to design, build, test, and deploy **AI agents for pre-specified clinical study workflows**.

The central idea is:

> An AI agent for clinical study work is not just an LLM. It is an LLM embedded in a workflow harness and a controlled running environment.

The book should help readers move from generic AI experimentation to bounded, auditable, testable clinical workflow automation.

## 2. Core framework

```text
AI Agent = LLM + Harness + Running Environment
```

### LLM

The reasoning and language component.

It can:

- interpret study documents;
- summarize and compare requirements;
- reason across SAP, ADaM, TLF, metadata, and code;
- draft findings and explanations;
- propose next review steps.

### Harness

The orchestration layer around the LLM.

It defines:

- the workflow objective;
- allowed tools;
- prompt templates;
- retrieval strategy;
- output schemas;
- validation checks;
- guardrails;
- logging and traceability;
- human review checkpoints.

### Running environment

The controlled place where the agent operates.

It includes:

- study documents;
- ADaM datasets and specifications;
- TLF shells and generated outputs;
- analysis code;
- metadata and standards;
- file permissions;
- compute environment;
- version control;
- audit logs.

## 3. Running example

The book's main worked example is:

> Verifying that TLF outputs derived from ADaM datasets follow the Statistical Analysis Plan of an ongoing study.

Short name:

```text
SAP -> ADaM -> TLF verification
```

This example is useful because it is realistic, bounded, high-value, and naturally requires both automation and human judgment.

## 4. Example workflow definition

### Objective

Verify whether generated tables, listings, and figures are consistent with the SAP and traceable to ADaM data and metadata.

### Inputs

- Statistical Analysis Plan
- TLF shells
- Generated TLF outputs
- ADaM datasets
- ADaM specifications
- Define.xml or metadata package
- Analysis code
- Study conventions
- Prior QC findings, if available

### Outputs

- Verification report
- Structured issue log
- Evidence map
- Human review checklist
- Machine-readable audit trail

### Agent tasks

1. Extract SAP analysis requirements.
2. Inventory planned and generated TLFs.
3. Map SAP requirements to TLF outputs.
4. Identify ADaM variables and derivations used by each TLF.
5. Check population definitions.
6. Check endpoint definitions.
7. Check visit windows and time points.
8. Check treatment groups and denominators.
9. Check summary statistics and inferential methods.
10. Check footnotes, titles, labels, and table structure.
11. Classify findings by type and severity.
12. Produce evidence-backed review output.

### Human review checkpoints

Human review remains required for:

- ambiguous SAP interpretation;
- clinical or statistical judgment;
- severity classification;
- protocol deviations or documented changes;
- final acceptance of findings.

## 5. Proposed book arc

### Part I: Foundations

Explain the clinical study workflow landscape and why AI agents need to be designed as controlled systems.

Candidate chapters:

1. Why AI agents for clinical study workflows?
2. What is an AI agent?
3. From open-ended chat to bounded clinical workflows
4. Clinical workflow decomposition: inputs, outputs, checks, risks

### Part II: Defining the workflow

Use the SAP -> ADaM -> TLF verification example to show how to specify an agent workflow.

Candidate chapters:

1. Study artifacts and traceability
2. Defining the verification objective
3. Requirements extraction from SAP
4. Mapping SAP requirements to TLF outputs
5. Designing output schemas and review criteria

### Part III: Developing the agent

Show how to build the harness.

Candidate chapters:

1. Prompt templates and task instructions
2. Tooling for documents, datasets, metadata, and code
3. Retrieval and evidence citation
4. Structured outputs and issue logs
5. Guardrails and failure handling

### Part IV: Testing the agent

Show how to evaluate the workflow before trusting it.

Candidate chapters:

1. Unit tests for workflow components
2. Scenario tests for clinical review cases
3. Regression tests across model and prompt changes
4. Human adjudication and metrics
5. Evidence quality, precision, recall, and reproducibility

### Part V: Deploying and governing the workflow

Show how to operationalize the workflow responsibly.

Candidate chapters:

1. Local study assistant deployment
2. Pipeline-integrated deployment
3. Review dashboards and issue workflows
4. Audit trails and reproducibility
5. Validation, change control, and governance

## 6. Example artifacts to build in the book

The book should include concrete artifacts readers can adapt:

- workflow definition YAML;
- prompt templates;
- output JSON schemas;
- SAP requirement extraction table;
- TLF inventory table;
- SAP-to-TLF traceability matrix;
- ADaM-to-TLF evidence map;
- structured finding log;
- human review checklist;
- scenario test suite;
- deployment checklist;
- governance checklist.

## 7. Finding schema sketch

```json
{
  "finding_id": "F-001",
  "category": "Population definition",
  "severity": "Major",
  "status": "requires_human_review",
  "sap_reference": "SAP Section 5.1",
  "tlf_reference": "Table 14.1.1",
  "adam_reference": "ADSL.SAFFL",
  "finding": "The safety population denominator appears inconsistent with the SAP definition.",
  "evidence": [
    "SAP states the safety population includes all randomized subjects who received at least one dose.",
    "Table 14.1.1 denominator excludes subjects with partial dosing records."
  ],
  "recommended_action": "Confirm SAFFL derivation and rerun denominator check."
}
```

## 8. Design principles

1. **Bound the workflow before choosing the model.**
2. **Make every agent output evidence-backed.**
3. **Separate confirmed findings from possible concerns.**
4. **Treat prompts, tools, and schemas as versioned study artifacts.**
5. **Use scenario tests, not vibes, to evaluate the agent.**
6. **Keep humans accountable for clinical and statistical judgment.**
7. **Prefer read-only review before autonomous modification.**
8. **Design for traceability from the beginning.**

## 9. Initial open questions

- Should the book remain centered on CSR/submission broadly, or narrow to clinical study workflow agents?
- Should the SAP -> ADaM -> TLF verification example use a fully synthetic study?
- Which public or synthetic ADaM/TLF examples should be used?
- Should examples be implemented in R, Python, or both?
- How much regulatory validation detail should be included in the first edition?
- Should the book include a minimal reference implementation of the harness?

## 10. Near-term next steps

1. Decide whether `wholegame.md` is a planning artifact only or should be adapted into the Quarto book structure.
2. Update `_quarto.yml` if we want the AI-agent workflow framing to become a formal part of the book.
3. Create a chapter stub for the AI agent concept.
4. Create a chapter stub for the SAP -> ADaM -> TLF verification example.
5. Define the first synthetic test scenario and artifacts.
6. Add a small workflow definition file under a future examples directory.

## 11. One-sentence positioning

> This book teaches clinical development teams how to engineer AI agents that execute bounded, testable, evidence-backed workflows across study documents, data, code, and outputs.
