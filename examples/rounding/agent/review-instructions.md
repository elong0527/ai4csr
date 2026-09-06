# Review unresolved R rounding calls

Read only the changed code, agent queue, repository instructions, and available
first-party function documentation.

For each queued call:

1. determine whether it rounds or may round a value;
2. cite the code location and evidence;
3. return `rounding`, `not_rounding`, or `uncertain`; and
4. propose a policy classification without editing the active policy.

Report the queued calls reviewed. Escalate missing or conflicting evidence to
the accountable standards owner. Do not inspect dependency internals or approve
policy changes.
