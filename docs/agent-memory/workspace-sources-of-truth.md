---
scope: project
keywords: workspace, docs, verification
last-updated: 2026-03-06
related-files: Cargo.toml, .gitignore, docpup.config.yaml, README.md, anthropic-ai-sdk/README.md, documentation/library-docs.md, documentation/indices/anthropic-sdk-rs-index.md, documentation/indices/claude-platform-index.md
---

# Workspace Sources Of Truth

This topic records the workspace-level rules that decide where to edit, where to read, and what commands actually validate a change.

## Editable Surfaces

- Treat `anthropic-ai-sdk/` and `examples/` as the editable product surface.
- Treat `documentation/anthropic-sdk-rs/` as a generated snapshot driven by `docpup.config.yaml`; edit the matching file under `examples/` first.
- Treat `documentation/claude-platform/` as local reference input, not repository product code.
- Update `anthropic-ai-sdk/README.md` when user-facing SDK usage changes; root `README.md` is only a pointer.
- Keep durable agent knowledge in `docs/agent-memory/`, not under `.context/`; `.context/` is for temporary cross-agent coordination.

## Documentation Routing

- Start Anthropic or Claude API questions at `documentation/library-docs.md`.
- Use the index files to narrow reads before opening individual documentation pages; the repo explicitly prefers local indices over memory-based recall.
- `documentation/indices/anthropic-sdk-rs-index.md` points at generated example source snapshots, not the live SDK crate.
- `documentation/indices/claude-platform-index.md` is the routing layer for platform behavior and feature docs.
- When freshness matters, local docs are still the first hop, but they are not a substitute for later verification against a current primary source.

## Cargo Scope Rules

- Root `Cargo.toml` is the canonical inventory of workspace members.
- Root `default-members` contains only `anthropic-ai-sdk`, so plain root `cargo build`, `cargo check`, and `cargo test` can miss breakage in `examples/`.
- Use `cargo check --workspace` after touching shared types, path dependencies, or root manifests.
- Validate example behavior from the example directory with `cargo run`; examples are standalone binaries, not tests inside the SDK crate.
- Add new example crates to root `members` immediately or workspace-aware tooling will ignore them.
- Rename or remove example crates in root `members` before cleaning up any generated docs references.

## Generated Docs and Ignore Rules

- `.gitignore` excludes `documentation/anthropic-sdk-rs/` and `documentation/claude-platform/`; these trees are expected to be regenerated locally.
- Because the generated docs are ignored, file diffs in `documentation/` are not a reliable signal for whether product code changed.
- The same ignore rule means implementation work and durable memory should stay out of `documentation/`.
- Scratch memory files must remain ignored through `**/.scratch.md`; they are staging material, not repo state.
- If a task cites a file under `documentation/anthropic-sdk-rs/examples/...`, map it back to the sibling under `examples/...` before editing.

## Planning Heuristics

- If a task changes public SDK surface, inspect both `anthropic-ai-sdk/` and at least one matching example crate before editing.
- If a task only changes docs, confirm whether the authoritative source is `anthropic-ai-sdk/README.md`, local reference docs, or generated snapshots.
- When the correct validation scope is unclear, start from root `Cargo.toml`; it tells you whether the change can affect only the SDK crate or the full workspace.
- When the correct code target is unclear, start from `documentation/library-docs.md`; it tells you whether the user is asking for editable code or reference-backed behavior.
