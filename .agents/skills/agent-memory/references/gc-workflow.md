# Garbage Collection Workflow

Systematic review to prevent stale memory from misleading agents. GC runs across all levels of the hierarchy — root and every initialized subfolder.

Do NOT auto-delete or auto-modify. Present findings and wait for human approval on every change.

## Steps

### Step 1: Staleness scan

For every topic file across all initialized levels:
- Read the "Last Updated" column in each INDEX.md
- Flag topics where `(today - last_updated) > 21 days`

### Step 2: Relevance check

For every topic file:
- Parse frontmatter `related-files` and verify each path still exists in the codebase
- If `related-files` is present, use it as the primary relevance signal
- If `related-files` is absent, fall back to checking if the topic's domain is still part of the project
- Flag topics that reference deleted or renamed code

### Step 3: Size audit

For every topic file:
- Flag files >150 lines → recommend split or prune
- Flag files <50 lines → recommend merging with a related topic

### Step 4: Orphan detection

For every `docs/agent-memory/` directory:
- List all `.md` files (excluding INDEX.md)
- Verify each has an entry in the corresponding INDEX.md
- Flag files without an INDEX.md entry as orphans

### Step 5: Routing-rule audit

For every AGENTS.md with a managed block:
- Parse each routing rule
- Verify the referenced file path exists
- Flag broken routing rules

### Step 6: Pitfall rotation

For every `known-pitfalls.md`:
- Check each pitfall entry
- Flag pitfalls with no related commits or references in the last 30 days
- Recommend removal or retention based on whether the pitfall's domain is still active

### Step 7: Cross-level deduplication

Compare root topics against subfolder topics:
- Flag content that exists at multiple levels
- Recommend where each piece of knowledge should live (most specific applicable level)
- Root should not duplicate subfolder-specific knowledge
- Subfolder should not repeat root-level knowledge

### Step 8: Subfolder coverage

Check for significant subfolders that lack a memory system:
- Subfolders with their own AGENTS.md but no `docs/agent-memory/`
- Subfolders with >20 files and distinct domain logic
- Recommend `drill-down` for uncovered significant subfolders

### Step 9: Present report

Organize findings by level (root first, then each subfolder). Use this format:

```markdown
## GC Report

### Root (`docs/agent-memory/`)

| Finding | Topic/File | Recommendation |
|---------|-----------|----------------|
| Stale (28d) | conventions.md | Review and update or confirm current |
| Oversized (180 lines) | architecture.md | Split into architecture.md + data-flow.md |
| Orphan | old-patterns.md | Add to INDEX.md or delete |

### Subfolder: src/api/

| Finding | Topic/File | Recommendation |
|---------|-----------|----------------|
| ...     | ...       | ...            |

### Uncovered Subfolders

| Subfolder | Reason | Recommendation |
|-----------|--------|----------------|
| src/workers/ | Has AGENTS.md, no memory system | Run `drill-down src/workers/` |
```

Wait for the user to approve, reject, or modify each recommendation before taking action.
