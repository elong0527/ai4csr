# Whole Game: AI Agents for Clinical Study Workflows

## Positioning

This book demonstrates how AI agents can complete selected clinical trial workflows in an AI-first way.

AI-first means the workflow is designed for an AI agent to perform the first structured pass: using tools to inspect study artifacts, checking them against prespecified expectations, preparing evidence-backed findings, and escalating judgment calls to humans.

This is a **demo, not a prescription**. The book intentionally does not cover full compliance implementation, because compliance depends on each organization's infrastructure, policies, validation process, and regulatory obligations.

## Audience

We assume readers have hands-on experience with clinical trial workflows following ICH guidance and CDISC standards. The book aims to help you understand how AI agents can empower your work in a systematic way.

## What is an AI Agent?

You may already use AI agents in small ways. For example, you might ask ChatGPT to review an SAP section, or ask Claude to draft R code for a baseline characteristics table. These are agentic tasks that simplify daily work in an ad hoc way.

This book moves from ad hoc agentic tasks to prespecified clinical workflows.

At its core, an AI agent is an LLM in a harness that can call tools iteratively to complete a task. Three terms are worth unpacking:

- **LLM** — the language model that reasons and generates responses.
- **Harness** — the framework that controls the agent loop: calling the LLM, invoking tools, and deciding when to stop or escalate.
- **Tools** — functions the agent can call to interact with study artifacts or systems.

For example, a tool can inspect ADaM variable metadata — dataset names, variable names, labels, types, controlled terminology, and analysis flags — so the agent can compare what exists in the data against what the SAP or TLF specification requires.

## Why Workflow?

Ad hoc AI assistance is useful, but clinical trial work is fundamentally workflow-driven. Tasks follow defined sequences, connect multiple deliverables, and require coordinated review across teams. When you assign such a task to a colleague, you hand them a workflow, not just a prompt. AI agents work the same way — they need to understand the workflow to do the job reliably.

## Example

Throughout the book we use one concrete, tedious, and time-consuming task as our running example:

> Verify that a CSR TLF package derived from ADaM datasets follows the Statistical Analysis Plan before database lock.

This workflow connects three key deliverables:

- SAP
- ADaM datasets
- TLF package

The AI agent acts as an independent reviewer assistant. It uses the LLM and tools, coordinated by the harness, to inspect each deliverable and check consistency across them. When a decision or judgment call is needed, it escalates to the right team members.

The goal is to design a workflow where the AI agent handles mechanical consistency checks, prepares evidence-backed findings, and supports human review and sign-off.
