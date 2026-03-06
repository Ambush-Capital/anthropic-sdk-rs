# Topic Operations

Three operations for managing topic files: `create`, `update`, and `record-pitfall`.

---

## Create

Create a new topic file and register it in INDEX.md.

### Step 1: Validate the topic name

- Must be lowercase kebab-case: `error-handling.md`, `api-conventions.md`
- Must be descriptive enough to decide whether to read from the filename alone
- Must not duplicate an existing topic file name at the same level

### Step 2: Determine scope and path

If `[path]` is provided, create the topic under `<path>/docs/agent-memory/`. Otherwise, default to the repo root's `docs/agent-memory/`.

Verify `docs/agent-memory/` exists at the target path. If not, inform the user to run `init` first.

### Step 3: Write the topic file

Create `docs/agent-memory/<topic-name>.md` with initial content:

```markdown
---
scope: project
keywords: <1-3 lowercase tags>
last-updated: <YYYY-MM-DD>
related-files: <source paths this topic covers>
---

# <Topic Name in Title Case>

<Brief description of what this topic covers — 1 sentence.>

## <First Section>

<Content. Follow content-rules.md: factual, action-oriented, non-obvious knowledge only.>
```

If the user provided context or the agent has knowledge to record, write substantive content immediately. Do not leave placeholder text in the final file.

### Step 4: Update INDEX.md

Add a row to the INDEX.md routing table:

```
| [<topic-name>.md](<topic-name>.md) | <one-line description> | <when to read this> | <YYYY-MM-DD> |
```

Verify INDEX.md stays under 80 lines and 15 topics. If exceeded, flag for the user.

### Step 5: Consider routing rule

If the topic covers a common task type (architecture changes, build failures, testing patterns), propose adding a routing rule to the AGENTS.md managed block. Present the proposed change — do not auto-commit.

---

## Update

Holistic rewrite of an existing topic file using a structured consolidation process.

### Step 1: Read the current file

Read the existing topic file in full. Understand its current structure, content, and frontmatter.

### Step 2: Verify against source

Read the relevant code/files referenced in the topic's frontmatter `related-files` to check current accuracy. If `related-files` is empty, scan the codebase for files related to the topic's keywords.

### Step 3: Consolidate and rewrite

A holistic rewrite follows these sub-steps:

1. **Deduplicate**: Merge semantically equivalent entries
2. **Resolve conflicts**: Most recent correction wins (see architecture.md Precedence Rules)
3. **Prune**: Remove entries that are no longer true or relevant
4. **Incorporate**: Add new knowledge from the current session
5. **Rewrite**: Produce a single coherent document reflecting current state

This is NOT an append — the new version replaces the old completely.

Rules:
- Preserve valuable existing content that is still accurate
- Keep under 200 lines. If exceeding, split into two topic files
- Update frontmatter fields (`last-updated`, `keywords`, `related-files`)
- Follow content rules: factual, action-oriented, non-obvious

### Step 4: Update INDEX.md date

Update the "Last Updated" column in INDEX.md to today's date for this topic.

---

## Record-Pitfall

Add an entry to known-pitfalls.md.

### Step 1: Read current pitfalls

Read `docs/agent-memory/known-pitfalls.md` at the target path.

### Step 2: Check for duplicates

If a similar pitfall already exists, update the existing entry instead of adding a new one.

### Step 3: Enforce the cap

If known-pitfalls.md already has 10 entries:
1. Evaluate each existing entry for current relevance
2. Remove the least relevant entry
3. Add the new entry

### Step 4: Write the entry

Add the pitfall in this format:
```markdown
### <Short descriptive title>

<1-3 sentences: what goes wrong, why, and how to avoid it.>
```

### Step 5: Propose AGENTS.md update

If the new pitfall should be in the top-5 (it is more relevant than the current #5), propose an update to the AGENTS.md managed block's "Top Pitfalls" section.

Present the proposed change — do not auto-commit.
