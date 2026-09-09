# Release record: <short title>

> Mark the record PROPOSED when no operating history exists. Do not invent
> human approvals. An advisory pilot, in which a person decides every action,
> is often the first operating mode.

- Artifact version: 0.1 (draft)
- Status: proposed | authorized | superseded
- Workflow: <same name as the workflow brief>
- Benchmark report version: <version of the accepted benchmark>
- Authors: <Biometrics owner; AI engineer>
- Date: <YYYY-MM-DD>

## Biometrics decision required

<The decision this record asks for: authorize the release or advisory pilot,
with operating roles, scope, and support confirmed.>

## Approved components

<Workflow and component versions entering real work.>

## Operating scope

<Target environment, users, inputs, trigger, schedule, expected outputs, and
explicit scope limits.>

## Execution environment and sandboxing

<Where agent-generated code is allowed to execute. Agent-generated code runs
only inside a sandbox: no network access, no writes outside the declared
workspace, and no access to credentials or production data stores. Name the
sandbox mechanism (container image, OS sandbox profile, or equivalent) and its
version. The benchmark harness runs inside the same sandbox. A release that
cannot name its sandbox is not ready for authorization.>

## Access permissions and human approval gates

<Permissions, approval points, and conditions for suspending or reversing the
release.>

## Installation, configuration, and verification

<What was installed and configured; verification results.>

## Monitoring measures and control bands

<Measures watched in operation and the bands that trigger review.>

## Support and recovery

<Support ownership, escalation contacts, and recovery procedure.>

## Engineering contribution

<Packaging, trigger and environment configuration, access boundary, logging
and monitoring connections, rollback preparation.>

## Evidence attached

<Verification outputs; state what was tested and what was not.>

## Accountable human gate

- Gate: authorize the release or advisory pilot.
- Authorized by: <named person; never invented> on <date>
- Decision: <pending | authorized | declined>

## Next-stage event

<The authorized release, with monitoring active, initiates Maintain.>
