# Whole Game: AI Agents for Clinical Study Workflows

## Positioning

This book demonstrates how AI agents can complete selected clinical trial workflows in an AI-first way.

AI-first means the AI agent proactively starts a prespecified workflow and engages with humans when judgment is needed to handle edge cases.

This is a **demo, not a prescription**. The book intentionally does not cover full compliance implementation, because compliance depends on each organization's infrastructure, policies, validation process, and regulatory obligations.

## Audience

We assume readers have hands-on experience with clinical trial workflows following ICH guidance and CDISC standards. The book aims to help you understand how AI agents can empower your work in a systematic way.

## What is an AI Agent?

You have likely worked with AI agents already. For example, you might ask ChatGPT to review your SAP, or ask Claude to write R code for a baseline characteristics table. These are AI agents helping you with ad hoc tasks.

At its core, an AI agent is an LLM in a harness that can call tools iteratively to complete a task. Three terms are worth unpacking:

- **LLM** — the language model that reasons and generates responses.
- **Harness** — the framework that controls the agent loop: calling the LLM, invoking tools, and deciding when to stop or escalate.
- **Tools** — functions the agent can call to interact with the outside world, such as reading files, running code, or querying a database.

## Why Workflow?

Ad hoc AI assistance is useful, but clinical trial work is fundamentally workflow-driven. Tasks follow defined sequences, connect multiple deliverables, and require coordinated review across teams. When you assign such a task to a colleague, you hand them a workflow, not just a prompt. AI agents work the same way — they need to understand the workflow to do the job reliably.

## Example

Throughout the book we use one concrete, tedious, and time-consuming task as our running example:

> Verify that a CSR TLF package derived from ADaM datasets follows the Statistical Analysis Plan before database lock.

This workflow connects three key deliverables:

- SAP
- ADaM datasets
- TLF package

The AI agent uses the LLM and tools, coordinated by the harness, to inspect each deliverable and check consistency across them. When a decision or judgment call is needed, it escalates to the right team members.

The goal is a workflow where AI agents handle the majority of the work and deliver a high-quality output ready for human sign-off.
