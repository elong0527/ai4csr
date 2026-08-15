# AGENTS.md

## Network

Web search is disabled. Do not search the web, browse, or fetch any URL.

There is exactly one exception. The study protocol may be downloaded from this
address and no other:

```
https://cdn.clinicaltrials.gov/large-docs/80/NCT02578680/Prot_SAP_001.pdf
```

If the protocol is already present in this folder, do not download it again.
If the download fails, stop and report it. Do not look for the protocol
somewhere else, and do not substitute a summary of the trial from memory.

## Branches and history

Use only the files that are present in the current working tree. Do not read
any other branch, commit, tag, stash, or the reflog.

This rules out retrieving content with commands such as `git show`, `git log`,
`git diff`, `git checkout`, `git restore`, `git worktree`, and any comparison
against a remote.

Other branches and earlier commits of this repository contain notes, expected
results, and grading material for this exercise. Reading them is not research.
It is looking up the answer.

