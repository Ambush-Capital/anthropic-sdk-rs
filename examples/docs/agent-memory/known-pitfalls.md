# Known Pitfalls - examples

examples-specific recurring mistakes. Max 10 entries. For project-wide pitfalls, see root `docs/agent-memory/known-pitfalls.md`.

## Pitfalls

### Admin examples use a different credential variable

Standard examples expect `ANTHROPIC_API_KEY`, but admin examples expect `ANTHROPIC_ADMIN_KEY` and build the client with `new_admin`. Copying a non-admin template into an admin path without changing credentials produces misleading auth failures.

### New examples are easy to forget in the workspace manifest

Each example is a standalone Cargo package and must be listed in root `Cargo.toml` `members`. A new crate can appear to work in isolation while staying invisible to workspace-wide commands.

### Documentation snapshots are not the example source of truth

`documentation/anthropic-sdk-rs/examples/...` mirrors the examples tree for lookup. Edit the matching file under `examples/...` or the next doc regeneration will overwrite the snapshot.

### Relative path depth changes by example nesting

Top-level example groups usually depend on `../../../anthropic-ai-sdk`, while admin examples usually need `../../../../anthropic-ai-sdk`. Copy a sibling Cargo manifest from the same subtree instead of guessing the relative path.
