# Init Workflow

Bootstrap the memory system at a given path (default: repo root).

## Prerequisites

- Verify `docs/agent-memory/` does not already exist at the target path. If it does, inform the user and stop.

## Steps

### Step 1: Create directory structure

Create `docs/agent-memory/` at the target path.

### Step 2: Create INDEX.md

Write `docs/agent-memory/INDEX.md` with the initial template:

```markdown
# Agent Memory Index

Topic routing table. Scan the "Read When" column to find relevant topic files.

| Topic | Description | Read When | Last Updated |
|-------|-------------|-----------|-------------|
| [known-pitfalls.md](known-pitfalls.md) | Recurring mistakes and failure modes | Always scan headings | <YYYY-MM-DD> |
```

### Step 3a: Create .scratch.md

Write `docs/agent-memory/.scratch.md` with the initial template:

```markdown
# Session Scratch

Staging area for session observations. Triaged at sync time — never persists across sessions.

<!-- Add observations below. Format: ### <short title> followed by 1-3 sentences. -->
```

### Step 3b: Update .gitignore

Append `**/.scratch.md` to the project's `.gitignore` if the pattern is not already present. This ensures scratch files at any level (root + subfolders) are never committed.

### Step 4: Create known-pitfalls.md

Write `docs/agent-memory/known-pitfalls.md` with the initial template:

```markdown
# Known Pitfalls

Recurring mistakes and failure modes. Max 10 entries. Remove least relevant when adding new.

## Pitfalls

<No pitfalls recorded yet. Add entries as they are discovered during development.>
```

### Step 5: Wire AGENTS.md managed block

Read the existing AGENTS.md at the target path (create it if it does not exist).

Insert the managed block from `references/always-active-behavior.md` (see "AGENTS.md Managed Block Template" section). Place it after any existing content but before any closing sections.

Use `<!-- managed:agent-memory:begin -->` / `<!-- managed:agent-memory:end -->` markers. If the markers already exist, replace the content between them.

Customize the routing rules:
- Remove rules that reference non-existent topic files
- Keep the `known-pitfalls.md` rule (it always exists after init)
- Add a generic fallback: "If unsure: read `docs/agent-memory/INDEX.md`"

**Present the proposed AGENTS.md changes to the user for approval before writing.**

### Step 6: Wire CLAUDE.md pointer

If CLAUDE.md exists at the target path and does not already reference AGENTS.md, add a line: `Read AGENTS.md for project conventions and agent memory.`

If CLAUDE.md does not exist, skip this step — do not create a CLAUDE.md just for the pointer.

### Step 7: Scan codebase for initial topics

Scan the project for patterns that warrant initial topic files:
- Look for existing architectural documentation, decision records, or convention files
- Check for build configuration complexity (CI/CD, multiple build targets)
- Identify external dependency quirks visible in lock files or config

Do NOT auto-create topic files from this scan. Instead, list recommendations for the user:
```
Recommended initial topics:
- architecture.md — <reason>
- conventions.md — <reason>
- external-deps.md — <reason>
```

The user decides which topics to create (via the `create` sub-command).

### Step 8: Identify significant subfolders

Scan for subfolders that might warrant their own memory:
- Subfolders with their own AGENTS.md
- Subfolders with >20 files and distinct domain logic
- Subfolders worked on independently from root

List recommendations but do NOT auto-initialize. The user decides (via the `drill-down` sub-command).
