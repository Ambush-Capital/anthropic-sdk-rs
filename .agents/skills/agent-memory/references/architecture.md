# Memory Architecture

Three-tier hierarchical file-based memory. The filesystem is the retrieval index — descriptive filenames and a two-hop navigation model simulate retrieval without RAG.

## Three Tiers

### Tier 1: Hot Memory (always loaded, rarely changes)

**Files**: AGENTS.md managed block + CLAUDE.md pointer

Automatically loaded every session by both Claude Code and Codex. Contains:
- Pointer to `docs/agent-memory/INDEX.md`
- 5-10 if-then routing rules mapping task types to topic files
- Top-5 active pitfalls (distilled from `known-pitfalls.md`)
- Subfolder memory table (if subfolders have their own memory)

**Size cap**: 30 lines. Changes require human review.

CLAUDE.md remains a pointer file (`Read AGENTS.md`) per existing convention.

### Tier 2: Warm Memory (navigation hub, changes at milestones)

**File**: `docs/agent-memory/INDEX.md`

Routing table listing every topic file with a one-line description, "Read When" guidance, and last-updated date. Agents scan this to find the right topic file.

**Size cap**: 80 lines. Max 15 topics per directory.

### Session Scratch (staging area, never persists)

**File**: `docs/agent-memory/.scratch.md`

Session-scoped staging area for uncertain observations. Agents write here when they notice something potentially worth remembering but aren't confident it's durable. Triaged at sync time — each entry is promoted to a topic file, recorded as a pitfall, or discarded. Gitignored — must never be committed. The `init` workflow adds `**/.scratch.md` to `.gitignore`.

**Not a tier** — scratch is ephemeral and does not participate in the navigation model.

### Tier 3: Cold Memory (topic files, change freely)

**Files**: `docs/agent-memory/<topic-name>.md`

Individual knowledge files containing one category of curated knowledge. Written as holistic rewrites (not append-only). Content must be factual, action-oriented, and not discoverable from reading the code.

Every topic file must start with YAML frontmatter:

```yaml
---
scope: project | <subfolder-name>
keywords: middleware, auth, error-handling
last-updated: YYYY-MM-DD
related-files: src/api/middleware.ts, src/api/auth.ts
---
```

- `scope`: `project` for root-level topics, or the subfolder name for subfolder-scoped topics
- `keywords`: 1-3 lowercase tags for relevance scanning and consolidation
- `last-updated`: ISO date, updated on every holistic rewrite
- `related-files`: Source paths this topic covers — used by GC to verify relevance

**Size cap**: 50-200 lines per file (including frontmatter). Under 50 → merge. Over 200 → split.

## Hierarchical Layout

Root captures project-wide knowledge. Subfolders capture domain-specific knowledge with increasing granularity.

### Scope Rules

| Level | AGENTS.md covers | docs/agent-memory/ covers |
|-------|-----------------|--------------------------|
| Root | Project-wide rules, conventions, top pitfalls, subfolder routing | Cross-cutting architecture, project-wide patterns, external deps |
| Significant subfolder | Domain-specific rules, subfolder pitfalls, pointer to subfolder memory | Domain architecture, domain-specific patterns |
| One level deeper (optional) | Narrow sub-domain rules if warranted | Sub-domain specifics only when parent memory is too broad |

### Full Directory Layout

```
<project-root>/
  AGENTS.md                              # Tier 1: project-wide rules + subfolder routing
  CLAUDE.md                              # Pointer to AGENTS.md
  docs/
    agent-memory/
      INDEX.md                           # Tier 2: topic routing table
      .scratch.md                        # Session staging area (gitignored)
      architecture.md                    # Cross-cutting: module boundaries, data flow
      known-pitfalls.md                  # Project-wide recurring mistakes (max 10)
      conventions.md                     # Naming, style, patterns
      external-deps.md                   # Library quirks, version constraints
      key-decisions.md                   # Architectural decisions with rationale

  src/api/                               # ← Significant subfolder
    AGENTS.md                            # API-specific rules + pitfalls
    docs/
      agent-memory/
        INDEX.md                         # API-specific topic routing
        .scratch.md                      # Session staging area (gitignored)
        middleware-chain.md              # Middleware order, auth flow
        known-pitfalls.md                # API-specific pitfalls (max 10)
```

### Naming Conventions

- `INDEX.md` — always uppercase (signals navigation, not content)
- Topic files — lowercase kebab-case: `error-handling.md`, `api-conventions.md`
- Names must be descriptive enough to decide whether to read from the filename alone
- Flat structure inside `docs/agent-memory/` — no subdirectories within it

## Two-Hop Navigation Model

**Hop 1**: Agent reads AGENTS.md (automatic every session). The managed block contains if-then routing rules:
```
- If modifying architecture: read docs/agent-memory/architecture.md
- If build/CI fails: read docs/agent-memory/build-and-ci.md
- If unsure about conventions: read docs/agent-memory/INDEX.md
- Always scan headings of docs/agent-memory/known-pitfalls.md
```

**Hop 2**: If no routing rule matches, agent reads INDEX.md, scans the "Read When" column, opens only relevant topic file(s).

Maximum two reads from cold start to relevant knowledge.

## What Makes a Subfolder "Significant"

A subfolder gets its own memory system when it: (a) has its own AGENTS.md or distinct domain logic, AND (b) is worked on independently from the root.

## Inheritance and Deduplication

- Subfolder memory **inherits** root memory — agents read both root AGENTS.md and subfolder AGENTS.md
- Subfolder memory must NOT repeat root-level knowledge — it adds specificity, not redundancy
- If a topic applies to both root and subfolder, keep it at root and reference it from subfolder INDEX.md
- During GC, check for duplication across levels and promote/demote as needed

## Precedence Rules

When memory conflicts, resolve in this order:

1. User's explicit correction in the current session
2. Subfolder memory overrides root memory for that domain
3. More recently updated topic file overrides older one
4. known-pitfalls.md overrides general topic content
5. Root memory is the default when subfolder has no opinion
