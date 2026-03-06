# Sync and Status Workflows

Two related operations: `sync` regenerates memory indices, `status` reports memory health.

---

## Sync

Regenerate INDEX.md from current topic files and propose AGENTS.md managed block updates.

### Step 0: Triage scratch file

If `docs/agent-memory/.scratch.md` exists and has entries:

1. Read each entry (identified by `###` headings)
2. For each entry, decide:
   - **Promote**: The observation is durable and non-obvious → create or update the relevant topic file
   - **Pitfall**: The observation describes a failure mode → run `record-pitfall`
   - **Discard**: The observation is session-specific or no longer relevant → skip
3. After triaging all entries, clear the file back to its template (preserve the header and format comment)

If `.scratch.md` does not exist or is empty, skip this step.

### Step 1: Inventory topic files

List all `.md` files in `docs/agent-memory/` (excluding INDEX.md and .scratch.md) at the target path.

For each file:
- Parse YAML frontmatter for `last-updated`, `keywords`, and `related-files`
- Fall back to git/filesystem last-modified date if frontmatter is missing or lacks `last-updated`
- Read the H1 heading and first paragraph to extract a description
- Count lines

### Step 2: Regenerate INDEX.md

Rewrite INDEX.md with updated entries:

```markdown
# Agent Memory Index

Topic routing table. Scan the "Read When" column to find relevant topic files.

| Topic | Description | Read When | Last Updated |
|-------|-------------|-----------|-------------|
| [<filename>](<filename>) | <description> | <guidance> | <YYYY-MM-DD> |
```

Preserve existing "Read When" guidance where it is still accurate. Update descriptions and dates.

Remove entries for topic files that no longer exist. Add entries for new topic files found on disk.

### Step 3: Propose AGENTS.md changes

Compare the current AGENTS.md managed block against the current state:

1. **Routing rules**: Do they point to existing files? Are any major topics missing a routing rule?
2. **Top-5 pitfalls**: Read known-pitfalls.md and select the 5 most relevant entries.
3. **Subfolder memory table**: Does it reflect all initialized subfolders?

If changes are needed, generate the updated managed block and present the diff. Do not auto-commit.

### Step 4: Run lightweight GC

Flag (but do not fix) obvious issues:
- Orphan files (in directory but not in INDEX.md)
- Oversized files (>200 lines)
- Stale topics (>21 days since last update)

Report findings alongside the sync results.

---

## Status

Show memory health metrics without making changes.

### Step 1: Inventory all levels

Find all initialized memory directories:
- Root: `docs/agent-memory/`
- Subfolders: `*/docs/agent-memory/`, `*/*/docs/agent-memory/`

### Step 2: Collect metrics per level

For each initialized level:
- Topic count (excluding INDEX.md and known-pitfalls.md)
- Stale count (last updated >21 days ago)
- Oversized count (>200 lines)
- Undersized count (<50 lines)
- Orphan count (files not in INDEX.md)
- known-pitfalls.md entry count

### Step 3: Present report

```markdown
## Memory Status

### Root

| Metric | Value | Status |
|--------|-------|--------|
| Topics | <n>/15 | <OK | WARN if >12> |
| Stale (>21d) | <n> | <OK if 0 | WARN> |
| Oversized (>200 lines) | <n> | <OK if 0 | ERROR> |
| Undersized (<50 lines) | <n> | <OK if 0 | INFO> |
| Orphans | <n> | <OK if 0 | WARN> |
| Pitfalls | <n>/10 | <OK> |
| INDEX.md lines | <n>/80 | <OK | WARN if >60> |

### Subfolder: <path>
<same table>
```

No changes are made. Status is read-only.
