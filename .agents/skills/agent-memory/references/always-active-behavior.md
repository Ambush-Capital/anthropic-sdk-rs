# Always-Active Behavior

The memory system is always active — like the Theorist pattern, it runs every session without explicit invocation. This defines the behavioral model that gets wired into the AGENTS.md managed block via the `init` sub-command.

## Session Lifecycle

### On Session Start (automatic)

1. Check if `docs/agent-memory/` exists. If not, the memory system is not initialized — skip all memory behavior.
2. Read INDEX.md to understand current memory state.
3. Scan headings of `known-pitfalls.md` to load active pitfalls into context.

### During the Session (continuous, background awareness)

- When learning something non-obvious (a pitfall, a constraint, a pattern), decide where to capture it:
  - **High confidence** (explicit human correction, confirmed pitfall, verified constraint): Write or update the relevant topic file directly.
  - **Uncertain** (pattern noticed once, possible constraint, unverified observation): Write to `.scratch.md` as a staging entry. Format: `### <short title>` followed by 1-3 sentences.
- When corrected by a human, record the lesson in the appropriate topic file and/or `known-pitfalls.md` (this is always high confidence).
- When making an architectural change, update `architecture.md` (or the subfolder equivalent).
- Topic file updates are holistic rewrites — re-read the existing file, incorporate new knowledge, rewrite the whole thing. Follow the consolidation sub-steps in `topic-operations.md`.
- Updates to topic files (Tier 3) happen automatically without human approval.

### On Session End / Before PR (automatic)

1. **Triage `.scratch.md`** — for each entry: promote to a topic file (via create/update), record as pitfall, or discard (session-specific). Then clear the file.
2. Run `sync` — regenerate INDEX.md from current topic files, update last-modified dates.
3. **Propose** (do not auto-commit) AGENTS.md managed block changes. Present diff to human for approval.
4. Run lightweight GC: flag orphans, oversized files, and stale topics. Report but do not auto-delete.

## Update Cadence

Following the Theorist model: update when understanding shifts, not when code changes. Roughly:

- **Topic files**: Update after investigation, implementation, or correction cycles — when there is something worth recording. Not after every small edit.
- **INDEX.md**: Regenerated at sync time (session end / pre-PR). Not updated on every topic file change.
- **AGENTS.md managed block**: Only changes when routing rules or top pitfalls change. Always requires human approval.

## Auto-Update vs. Approval

| Layer | Auto-update? | Rationale |
|-------|-------------|-----------|
| Topic files (Tier 3) | Yes | Low-stakes, domain-specific, easy to rewrite |
| INDEX.md (Tier 2) | Yes (at sync) | Mechanical regeneration from current topic files |
| AGENTS.md managed block (Tier 1) | **No — propose only** | Hot memory affects every future session. LLM-generated context in the hot path hurts performance |

## AGENTS.md Managed Block Template

The `init` sub-command installs this managed block into AGENTS.md. The block uses `<!-- managed:agent-memory:begin -->` / `<!-- managed:agent-memory:end -->` markers for idempotent updates.

```markdown
<!-- managed:agent-memory:begin -->
## Agent Memory

Read `docs/agent-memory/INDEX.md` for the full topic index.

### Routing Rules
- If modifying architecture: read `docs/agent-memory/architecture.md`
- If build/CI fails: read `docs/agent-memory/build-and-ci.md`
- If unsure about conventions: read `docs/agent-memory/conventions.md`
- Always scan headings of `docs/agent-memory/known-pitfalls.md`
<!-- Precedence: user correction > subfolder > recent topic > pitfalls > root default -->

<!-- memory:pitfalls:begin -->
### Top Pitfalls
1. <most relevant pitfall>
2. <second most relevant>
3. <third>
4. <fourth>
5. <fifth>
<!-- memory:pitfalls:end -->

### Subfolder Memory
| Subfolder | Domain | Memory Index |
|-----------|--------|-------------|
<!-- managed:agent-memory:end -->
```

Customize routing rules and pitfalls for each project. The template above is a starting point — routing rules should reflect actual topic files that exist.
