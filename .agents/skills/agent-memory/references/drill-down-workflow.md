# Drill-Down Workflow

Bootstrap the memory system for a significant subfolder. This creates a subfolder-level memory hierarchy that inherits from root but adds domain-specific knowledge.

## Prerequisites

- Root memory system must be initialized (`docs/agent-memory/` exists at repo root)
- The target subfolder should be "significant": (a) has its own AGENTS.md or distinct domain logic, AND (b) is worked on independently from the root

If the target subfolder does not meet significance criteria, inform the user and suggest keeping knowledge at the root level instead.

## Steps

### Step 1: Create subfolder memory directory

Create `<subfolder>/docs/agent-memory/` directory.

### Step 2: Create subfolder INDEX.md

Write `<subfolder>/docs/agent-memory/INDEX.md`:

```markdown
# Agent Memory Index — <Subfolder Name>

Topic routing table for `<subfolder>/`. Inherits root memory — read root `docs/agent-memory/INDEX.md` for project-wide topics.

| Topic | Description | Read When | Last Updated |
|-------|-------------|-----------|-------------|
| [known-pitfalls.md](known-pitfalls.md) | <Subfolder>-specific recurring mistakes | Always scan headings | <YYYY-MM-DD> |
```

### Step 3: Create subfolder known-pitfalls.md

Write `<subfolder>/docs/agent-memory/known-pitfalls.md`:

```markdown
# Known Pitfalls — <Subfolder Name>

<Subfolder>-specific recurring mistakes. Max 10 entries. For project-wide pitfalls, see root `docs/agent-memory/known-pitfalls.md`.

## Pitfalls

<No pitfalls recorded yet.>
```

### Step 4: Wire subfolder AGENTS.md

Read the subfolder's AGENTS.md (create it if it does not exist).

Insert a managed block similar to the root, but scoped to the subfolder's domain:

```markdown
<!-- managed:agent-memory:begin -->
## Agent Memory — <Subfolder Name>

Read `docs/agent-memory/INDEX.md` for <subfolder>-specific topics.
Also read root AGENTS.md for project-wide rules (inherited).

### Routing Rules
- Always scan headings of `docs/agent-memory/known-pitfalls.md`
- If unsure: read `docs/agent-memory/INDEX.md`

### Top Pitfalls
<None recorded yet>
<!-- managed:agent-memory:end -->
```

**Present the proposed subfolder AGENTS.md changes for human approval.**

### Step 5: Update root subfolder memory table

Read the root AGENTS.md managed block. Add the new subfolder to the "Subfolder Memory" table:

```markdown
| `<subfolder>/` | <domain description> | `<subfolder>/docs/agent-memory/INDEX.md` |
```

**Present the proposed root AGENTS.md changes for human approval.**

### Step 6: Check for content to migrate

Scan the root `docs/agent-memory/` for topics that might be subfolder-specific:
- Topics whose content primarily references files within the target subfolder
- Sections within root topics that could be extracted to subfolder topics

List recommendations but do not auto-migrate. The user decides what to move.
