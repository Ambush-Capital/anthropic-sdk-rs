---
name: agent-memory
description: Maintain a three-tier hierarchical file-based memory system (AGENTS.md → INDEX.md → topic files) that helps LLM agents retain operational knowledge across sessions. Use when bootstrapping agent memory, creating or updating topic files, recording pitfalls, running garbage collection, syncing memory indices, checking memory health, or drilling down into subfolder memory. Do not use for writing human-facing documentation (README, CHANGELOG), RAG or MCP setup, or managing AGENTS.md content outside the memory managed block.
---

# Agent Memory

Load and follow the canonical skill definition:

1. Read `.agents/skills/agent-memory/SKILL.md` in full.
2. Read all files in `.agents/skills/agent-memory/references/`.
3. Follow the workflow exactly as defined.
