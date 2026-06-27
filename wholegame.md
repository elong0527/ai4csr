# Whole Game: AI Agents for Clinical Study Workflows

## One-sentence positioning

This book demonstrates how 
AI agents can complete selected clinical trial workflows in an AI-first way.

AI-first means the AI agent proactively start a prespecified workflow and 
engage with human when needed to handle edge cases.

This is a **demo, not a prescription**. 
the book intentionally does not cover full compliance implementation, because compliance depends on each company's or organization's infrastructure, policies, validation process, and regulatory obligations.

## Audience

We assume readers have hands on experience for clinical trial workflow following ICH guidance, CDSIC standard. 
The book should help them understand how AI agents can empower you in a systematic way.

## What's an AI agents

We have been working with different type of AI agents every day.
For example, you might ask ChatGPT to review your SAP or ask Claude code to create R code in building a baseline charactistic table.
They are AI agents to simplify your daily work in an adhoc way.

In short, AI agents is an LLM in a harness that can call tools iteratively to complete a task.

There are three terms that worth look into. 
LLM, harness and tools. As an exercise, asking an AI agent to explain them to you.

## Why workflow

By look into the two examples, a common pattern is that 
thise tasks typically requires to follow a workflow 
in clinical trial development. 
Your AI agent needs to understand such workflow 
like when you assign the task to a colleague.

## Example

Let's pick a teidious and time consuming work to an AI-first workflow.

> Verify that TLF package of a CSR derived from ADaM datasets follow the Statistical Analysis Plan before database lock.

The workflow connects 3 key deliverables:

- SAP;
- ADaM datasets;
- TLF packages

The AI agent should use LLM and tools to inspect the deliverables copedinate by harness, check consistency across the deliverables. 
Escalate to right human members when decisions or judgements are needed.

Our goal is to design a workflow that AI agents handle majority of the work to deliver high quality work for human sign off.
