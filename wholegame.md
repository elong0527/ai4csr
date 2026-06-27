# Whole Game: AI Agents for Clinical Study Workflows

This document is the working game plan for evolving **AI for Clinical Study Reports and Submission** toward a practical book that introduces AI agents to **clinical statisticians and statistical programmers**.

## 1. Book focus

The first audience is not general AI researchers. The first audience is:

- clinical statisticians;
- statistical programmers;
- statistical programming leads;
- study statisticians;
- data standards and analysis-results reviewers;
- clinical development teams who review SAP, ADaM, and TLF deliverables.

The book introduces how to design, build, test, and deploy **AI agents for pre-specified clinical study workflows**.

The central idea is:

> An AI agent for clinical study work is not just an LLM. It is an LLM equipped with tools, embedded in a workflow harness, and operated inside a controlled running environment.

The book should help readers move from generic AI experimentation to bounded, auditable, testable clinical workflow automation.

## 2. Why this matters for statisticians and programmers

Clinical statisticians and programmers already work with structured, high-stakes workflows:

- interpreting the SAP;
- specifying estimands, endpoints, populations, and analysis methods;
- deriving ADaM datasets;
- producing tables, listings, and figures;
- performing independent QC;
- explaining discrepancies;
- preparing evidence for CSR and submission packages.

AI agents are useful in this setting only when they respect the way clinical work is actually done:

- every claim needs evidence;
- every output needs traceability;
- every study has context and conventions;
- every automation has limits;
- humans remain accountable for scientific and regulatory judgment.

The book should therefore teach AI agents as **workflow systems**, not as chatbots.

## 3. Core framework

```text
AI Agent = LLM + Tools + Harness + Running Environment
```

This four-part framing should be introduced early and used throughout the book.

### LLM

The LLM is the reasoning and language component.

It can:

- interpret study documents;
- summarize and compare requirements;
- reason across SAP, ADaM, TLF, metadata, and code;
- draft findings and explanations;
- propose next review steps.

But the LLM alone is not enough. Without tools, context, workflow boundaries, and verification, it is only a general-purpose text generator.

### Tools

Tools are the capabilities the agent can call to inspect, compute, retrieve, validate, or transform information.

For clinical study workflows, tools may include:

- document parsers for SAP, protocol, shells, CSR sections, and reviewer guides;
- dataset readers for ADaM or SDTM files;
- metadata readers for define.xml, specification spreadsheets, controlled terminology, and analysis-results metadata;
- code search over R, Python, or SAS programs;
- table parsers for generated TLF outputs;
- statistical check scripts for denominators, visit windows, populations, and summary statistics;
- traceability tools that link SAP requirements to ADaM variables, programs, and TLF outputs;
- schema validators for structured findings and reports;
- report generators that produce markdown, HTML, JSON, or issue logs.

Tools matter because they let an agent move from **talking about** a workflow to **working inside** a workflow.

A simple distinction for readers:

| Without tools | With tools |
|---|---|
| The LLM guesses from pasted text | The agent inspects actual files |
| The LLM describes a check | The agent runs the check |
| The LLM gives an opinion | The agent cites evidence |
| The answer is hard to reproduce | The result can be logged and rerun |

Tool use must be controlled. A clinical workflow agent should know:

- which tools it is allowed to use;
- which files it may read;
- whether it may write or only review;
- how tool outputs are logged;
- how failures are reported;
- when human review is required.

### Harness

The harness is the orchestration layer around the LLM and tools.

It defines:

- the workflow objective;
- allowed tools and permissions;
- prompt templates;
- retrieval strategy;
- output schemas;
- validation checks;
- guardrails;
- logging and traceability;
- human review checkpoints.

The harness is what turns a general LLM plus tools into a repeatable clinical workflow agent.

### Running environment

The running environment is the controlled place where the agent operates.

It includes:

- study documents;
- ADaM datasets and specifications;
- TLF shells and generated outputs;
- analysis code;
- metadata and standards;
- file permissions;
- compute environment;
- package versions;
- version control;
- audit logs.

For clinical work, the running environment is not a detail. It is part of the trust model.

## 4. Running example

The book's main worked example is:

> Verifying that TLF outputs derived from ADaM datasets follow the Statistical Analysis Plan of an ongoing study.

Short name:

```text
SAP -> ADaM -> TLF verification
```

This example is useful because it is realistic, bounded, high-value, and naturally requires both automation and human judgment.

It also speaks directly to clinical statisticians and programmers because it connects familiar artifacts:

```text
SAP requirements
  -> ADaM variables and derivations
  -> analysis programs
  -> generated TLF outputs
  -> CSR or submission evidence
```

## 5. Example workflow definition

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
5. Use tools to inspect actual datasets, metadata, outputs, and code.
6. Check population definitions.
7. Check endpoint definitions.
8. Check visit windows and time points.
9. Check treatment groups and denominators.
10. Check summary statistics and inferential methods.
11. Check footnotes, titles, labels, and table structure.
12. Classify findings by type and severity.
13. Produce evidence-backed review output.

### Human review checkpoints

Human review remains required for:

- ambiguous SAP interpretation;
- clinical or statistical judgment;
- severity classification;
- protocol deviations or documented changes;
- final acceptance of findings.

## 6. What readers should learn first

For clinical statisticians and programmers, the first learning goal is practical literacy:

1. What an AI agent is.
2. How an agent differs from a chatbot.
3. Why tools are essential.
4. Why harness design matters.
5. Why the running environment affects trust.
6. How to define a clinical workflow before automating it.
7. How to test agent behavior against known scenarios.
8. How to deploy with human review and auditability.

A concise teaching sequence:

```text
Chatbot
  -> LLM with instructions
  -> LLM with tools
  -> LLM with tools inside a harness
  -> validated workflow agent in a controlled environment
```

## 7. Proposed book arc

### Part I: Foundations for clinical teams

Explain the clinical study workflow landscape and why AI agents need to be designed as controlled systems.

Candidate chapters:

1. Why AI agents for clinical study workflows?
2. What clinical statisticians and programmers need to know about LLMs
3. From chatbot to workflow agent
4. Tools: how agents inspect documents, data, code, and outputs
5. Harness and running environment: making agents bounded and auditable

### Part II: Defining the workflow

Use the SAP -> ADaM -> TLF verification example to show how to specify an agent workflow.

Candidate chapters:

1. Study artifacts and traceability
2. Defining the verification objective
3. Requirements extraction from SAP
4. Mapping SAP requirements to TLF outputs
5. Designing output schemas and review criteria

### Part III: Developing the agent

Show how to build the harness and connect tools.

Candidate chapters:

1. Prompt templates and task instructions
2. Tooling for documents, datasets, metadata, and code
3. Retrieval and evidence citation
4. Structured outputs and issue logs
5. Guardrails and failure handling

### Part IV: Testing the agent

Show how to evaluate the workflow before trusting it.

Candidate chapters:

1. Unit tests for workflow components and tools
2. Scenario tests for clinical review cases
3. Regression tests across model, prompt, tool, and environment changes
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

## 8. Example artifacts to build in the book

The book should include concrete artifacts readers can adapt:

- workflow definition YAML;
- tool inventory and permission table;
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

## 9. Tool inventory sketch

A tool inventory makes the agent design concrete.

| Tool | Purpose | Example input | Example output | Risk control |
|---|---|---|---|---|
| SAP parser | Extract analysis requirements | `sap.pdf` | requirement table | cite section/page |
| ADaM reader | Inspect dataset contents | `adsl.xpt` | variables, labels, counts | read-only access |
| Metadata reader | Inspect specs and define.xml | `define.xml` | variable metadata | schema validation |
| TLF parser | Read generated outputs | `table14-1-1.rtf` | table structure and values | preserve source file |
| Code search | Find derivation or table code | `*.R`, `*.sas` | matched programs and lines | no code edits by default |
| Statistical checker | Recompute selected checks | dataset + rule | pass/fail + evidence | deterministic script |
| Finding validator | Validate issue schema | finding JSON | valid/invalid | required fields |
| Report generator | Create review package | issue log | HTML/markdown report | versioned output |

This table should evolve into a reusable template for any clinical workflow agent.

## 10. Finding schema sketch

```json
{
  "finding_id": "F-001",
  "category": "Population definition",
  "severity": "Major",
  "status": "requires_human_review",
  "sap_reference": "SAP Section 5.1",
  "tlf_reference": "Table 14.1.1",
  "adam_reference": "ADSL.SAFFL",
  "tool_evidence": [
    {
      "tool": "SAP parser",
      "source": "sap.pdf",
      "evidence": "SAP states the safety population includes all randomized subjects who received at least one dose."
    },
    {
      "tool": "ADaM reader",
      "source": "adsl.xpt",
      "evidence": "Safety flag derivation and denominator counts differ from expected rule."
    }
  ],
  "finding": "The safety population denominator appears inconsistent with the SAP definition.",
  "recommended_action": "Confirm SAFFL derivation and rerun denominator check."
}
```

## 11. Design principles

1. **Start with the clinical workflow, not the model.**
2. **Bound the workflow before choosing tools.**
3. **Give the agent tools only when the task requires them.**
4. **Make every agent output evidence-backed.**
5. **Separate confirmed findings from possible concerns.**
6. **Treat prompts, tools, schemas, and environments as versioned study artifacts.**
7. **Use scenario tests, not vibes, to evaluate the agent.**
8. **Keep humans accountable for clinical and statistical judgment.**
9. **Prefer read-only review before autonomous modification.**
10. **Design for traceability from the beginning.**

## 12. Initial open questions

- Should the book title remain centered on CSR/submission, or shift toward clinical study workflow agents?
- Should the first chapters explicitly target clinical statisticians and programmers before broadening to other audiences?
- Should the SAP -> ADaM -> TLF verification example use a fully synthetic study?
- Which public or synthetic ADaM/TLF examples should be used?
- Should examples be implemented in R, Python, or both?
- How much regulatory validation detail should be included in the first edition?
- Should the book include a minimal reference implementation of the harness?
- Which tools should be included in the first minimal agent?

## 13. Near-term next steps

1. Use `wholegame.md` as the planning artifact for reframing the book.
2. Draft an introductory chapter: "AI agents for clinical statisticians and programmers".
3. Draft a concept chapter: "LLM, tools, harness, and running environment".
4. Draft a worked-example chapter for SAP -> ADaM -> TLF verification.
5. Create a tool inventory template for the worked example.
6. Define the first synthetic test scenario and artifacts.
7. Add a small workflow definition file under a future examples directory.
8. Later, update `_quarto.yml` when the revised structure is ready to become formal book content.

## 14. One-sentence positioning

> This book teaches clinical statisticians and programmers how to engineer AI agents that use LLMs, tools, workflow harnesses, and controlled environments to execute bounded, testable, evidence-backed clinical study workflows.
