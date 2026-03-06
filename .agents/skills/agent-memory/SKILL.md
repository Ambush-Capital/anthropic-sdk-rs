---
name: agent-memory
display_name: Agent Memory
invoke_prompt: "Use $agent-memory init to bootstrap, $agent-memory create <topic> to add a topic, $agent-memory gc to garbage collect, or $agent-memory status to check health."
description: Maintain a three-tier hierarchical file-based memory system (AGENTS.md → INDEX.md → topic files) that helps LLM agents retain operational knowledge across sessions. Use when bootstrapping agent memory, creating or updating topic files, recording pitfalls, running garbage collection, syncing memory indices, checking memory health, or drilling down into subfolder memory. Do not use for writing human-facing documentation (README, CHANGELOG), RAG or MCP setup, or managing AGENTS.md content outside the memory managed block.
---

# Agent Memory

Maintain a three-tier hierarchical file-based memory system that helps LLM agents retain operational knowledge across sessions. The filesystem is the retrieval index — no RAG, no MCP, no search server.

## Input

`$ARGUMENTS` contains any text passed after the skill name at invocation time.

Parse `$ARGUMENTS` to determine the sub-command:

| Arguments | Action | Workflow |
|-----------|--------|----------|
| `init [path]` | Bootstrap memory system at path (default: repo root) | `references/init-workflow.md` |
| `create <topic-name> [path]` | Create a new topic file and update INDEX.md | `references/topic-operations.md` |
| `update <topic-name> [path]` | Holistic rewrite of existing topic file | `references/topic-operations.md` |
| `record-pitfall <summary>` | Add entry to known-pitfalls.md (max 10) | `references/topic-operations.md` |
| `gc [path]` | Run garbage collection across all levels | `references/gc-workflow.md` |
| `sync [path]` | Regenerate INDEX.md + propose AGENTS.md changes | `references/sync-workflow.md` |
| `status [path]` | Show memory health metrics | `references/sync-workflow.md` |
| `drill-down <subfolder>` | Bootstrap memory for a significant subfolder | `references/drill-down-workflow.md` |

If `$ARGUMENTS` matches none of the above sub-commands, default to `status`.

## Shared Rules

1. Read `references/architecture.md` for the three-tier structure, hierarchy, scope rules, and naming conventions before any operation.
2. Read `references/content-rules.md` before writing or updating any topic file.
3. All topic file updates are holistic rewrites — re-read the existing file, incorporate new knowledge, rewrite the entire file. Never append.
4. AGENTS.md managed block changes are **proposed only** — present the diff for human approval. Never auto-commit hot memory changes.
5. Topic files (Tier 3) and INDEX.md (Tier 2) auto-update without human approval.

## Execution

1. Determine the sub-command from the table above.
2. Read the corresponding workflow file in `references/`.
3. Read `references/architecture.md` and `references/content-rules.md` for shared context.
4. Follow the workflow exactly as defined.

## Always-Active Behavior

This skill also defines continuous background awareness for agents working in a project with an initialized memory system. Read `references/always-active-behavior.md` for the session lifecycle (on start, during work, on session end) and the instructions wired into the AGENTS.md managed block via `init`.

Agents do NOT need to invoke this skill explicitly to benefit — the always-active instructions in AGENTS.md guide background memory maintenance. Explicit sub-commands are for targeted operations.

## Constraints

1. Never auto-commit AGENTS.md managed block changes — always propose and wait for human approval. Per research: LLM-generated context in the hot path hurts agent performance.
2. Topic files must stay under 200 lines. Under 50 lines → consider merging. Over 200 → must split or prune.
3. known-pitfalls.md entries capped at 10 per level. Remove least relevant when adding new.
4. INDEX.md capped at 80 lines and 15 topics per directory.
5. All instructions must be agent-agnostic — no tool-specific names, no agent persona references.
6. Information lives at the most specific level where it applies. Root memory never duplicates subfolder knowledge.
7. Content must be factual, action-oriented, and NOT discoverable from reading the code itself. Generic overviews and code summaries are prohibited.
