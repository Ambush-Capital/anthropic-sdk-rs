# ExecPlan Template

This template extends the ExecPlan format defined in `PLANS.md`. If `PLANS.md` exists in the target repo, read it first and follow its rules. This template adds: phased milestones with risk/complexity scoring, and a changelog.

When writing an ExecPlan to a standalone `.md` file, omit the triple-backtick fence — the file content IS the plan.

---

## Skeleton

Use this structure when generating a new ExecPlan. Replace all `<placeholders>` with real content. Remove any sections that have no content (do not leave empty sections).

```
# <Short, action-oriented title>

<!-- theme: <theme-name> -->

This ExecPlan is a living document. The sections Progress, Surprises & Discoveries, Decision Log, and Outcomes & Retrospective must be kept up to date as work proceeds.

Maintained in accordance with PLANS.md (if checked into the repo, reference its path here).


## Purpose / Big Picture

Explain in a few sentences what someone gains after this change and how they can see it working. State the user-visible behavior this plan will enable. Write for someone who has never seen this repo.


## Progress

- [ ] (<YYYY-MM-DD HH:MMZ>) <initial task description>

Update this section at every stopping point. Split partially completed tasks into "done" and "remaining" entries. Use timestamps to track pace.


## Surprises & Discoveries

- Observation: None yet.
  Evidence: N/A

Document unexpected behaviors, bugs, performance findings, or insights. Include concise evidence (test output, logs).


## Decision Log

- Decision: None yet.
  Rationale: N/A
  Date/Author: <YYYY-MM-DD> / <name>

Record every decision made while working on this plan. Include the reasoning and who made it.


## Outcomes & Retrospective

Summarize outcomes, remaining gaps, and lessons learned at major milestones or at completion. Compare results against the original Purpose.


## Context and Orientation

Describe the current state relevant to this task as if the reader knows nothing. Name key files and modules by full repository-relative path. Define any non-obvious terms. Do not refer to prior plans unless they are checked into the repo (in which case, reference by path).


## Plan of Work

### Risk & Complexity Summary

| Phase | Description | Risk | Complexity | Est. LOC | Dependencies |
|-------|------------|------|-----------|----------|-------------|
| Phase 1 | <description> | <Low/Medium/High> | <1-5> | <n> | None |
| Phase 2 | <description> | <Low/Medium/High> | <1-5> | <n> | Phase 1 |

Risk scores:
- **Low** — isolated change, easily reversible, single system
- **Medium** — touches shared code, multiple files, needs testing
- **High** — cross-cutting, hard to reverse, multiple systems, behavioral change

Complexity scores:
- **1** — trivial (<10 LOC, single file)
- **2** — small (10-50 LOC, 1-3 files)
- **3** — moderate (50-200 LOC, multiple files, some domain knowledge)
- **4** — significant (200-500 LOC, cross-module, deep domain knowledge)
- **5** — large (500+ LOC, architectural, requires design review)

### Phase 1: <Title>

Scope: <what exists at the end of this phase that didn't exist before>

Risk: <Low/Medium/High> | Complexity: <1-5> | Est. LOC: <n>

Dependencies: None

Edits (list every file touched in this phase):

1. **`<repo-relative/path/to/file>`** — <Create | Modify | Delete>
   - <What to insert, replace, or remove. Name functions/types/methods explicitly.>
   - <Why this change is needed — tie back to phase scope.>

2. **`<repo-relative/path/to/another-file>`** — <Create | Modify | Delete>
   - <Details as above.>

Acceptance:
- Run: `<exact command>` | Expected: `<output or behavior>`
- Observe: `<specific UI state, file content, or system behavior>`

### Phase 2: <Title>

Scope: <what exists at the end of this phase that didn't exist before>

Risk: <Low/Medium/High> | Complexity: <1-5> | Est. LOC: <n>

Dependencies: Phase 1

Edits (same format as Phase 1 — list every file, name every symbol, describe every change):

1. **`<repo-relative/path>`** — <Create | Modify | Delete>
   - <Details.>

Acceptance:
- Run: `<exact command>` | Expected: `<output or behavior>`

(Add more phases as needed. Each phase must be independently verifiable.)


## Concrete Steps

State the exact commands to run and the working directory for each. Show expected output so a novice can compare. Update this section as work proceeds.

    cd <working-directory>
    <command>
    # Expected: <output>


## Validation and Acceptance

Describe how to start or exercise the system and what to observe. Phrase acceptance as behavior with specific inputs and outputs. Include test commands and expected results.


## Idempotence and Recovery

Describe whether steps can be safely repeated. If a step is risky, provide retry or rollback instructions.


## Artifacts and Notes

Include concise transcripts, diffs, or snippets that prove success. Use indented blocks (not fenced code blocks inside the plan).


## Interfaces and Dependencies

Name the libraries, modules, and services used and why. Specify types, interfaces, and function signatures that must exist after implementation. Use stable fully-qualified names.


## Changelog

- <YYYY-MM-DD> <author>: Initial plan created.
```

---

## Formatting Reminders

- Write in plain prose. Prefer sentences over lists in narrative sections.
- Checklists are only for the Progress section.
- Do not nest triple-backtick code fences inside the plan — use indented blocks for code/commands.
- Two newlines after every heading.
- Define every term of art immediately upon first use.
- Err on the side of over-explaining user-visible effects.
