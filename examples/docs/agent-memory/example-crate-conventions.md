---
scope: examples
keywords: examples, cargo, env
last-updated: 2026-03-06
related-files: Cargo.toml, docpup.config.yaml, examples/messages/messages/Cargo.toml, examples/messages/stream-messages/Cargo.toml, examples/files/list-files/Cargo.toml, examples/admin/api-keys/list-api-keys/Cargo.toml
---

# Example Crate Conventions

This topic records the conventions that matter when adding or updating standalone example crates.

## Workspace Integration

- Every example directory is a standalone Cargo package and must also be listed in root `Cargo.toml` `members`.
- Root `default-members` excludes the examples, so a plain root build does not prove a new example compiles.
- Validate a new example with both `cargo check --workspace` and a targeted `cargo run` from the example directory.
- Keep the package name simple and directory-aligned; the workspace manifest is the main inventory of example coverage.
- When copying an existing example, start from a sibling in the same domain so the relative `anthropic-ai-sdk` path depth stays correct.

## Dependency and Edition Patterns

- Non-admin examples nested three levels deep usually use `anthropic-ai-sdk = { path = "../../../anthropic-ai-sdk" }`.
- Admin examples nested four levels deep usually use `anthropic-ai-sdk = { path = "../../../../anthropic-ai-sdk" }`.
- Most examples use `edition = "2024"`, but the Files examples currently use `edition = "2021"` and a slightly different `tracing-subscriber` dependency shape.
- Copy the nearest in-domain Cargo manifest before normalizing versions; the tree is not fully homogenized today.
- Only add `futures-util` when the example consumes a stream; `messages/stream-messages` is the existing template.

## Runtime Conventions

- Standard API examples read `ANTHROPIC_API_KEY`.
- Admin examples read `ANTHROPIC_ADMIN_KEY` and build the client with `AnthropicClient::new_admin::<AdminError>(...)`.
- Most examples accept `ANTHROPIC_API_VERSION` and default it to `"2023-06-01"`.
- Most non-admin examples initialize `tracing_subscriber::fmt()` with verbose developer-oriented formatting.
- Several admin examples return `Result<_, AdminError>` directly instead of manual logging; preserve the style already used in the local example cluster you edit.

## Example-to-Docs Relationship

- `docpup.config.yaml` builds `documentation/anthropic-sdk-rs/` from the repo's `examples/` tree.
- The generated documentation copy is for lookup, not editing. Change the real example first.
- If a task references `documentation/anthropic-sdk-rs/examples/...`, map it back to the matching `examples/...` path before editing.
- Example code is the practical contract for README snippets and public SDK usage; keep imports and constructor patterns aligned with the SDK README.
- When adding a new public feature, decide whether it needs an example crate immediately; this repo treats examples as part of the product surface, not optional extras.

## Validation Expectations

- Run the example from its own directory after editing it; that catches path-dependency and environment-variable mistakes faster than a root build.
- When a change touches shared SDK imports, re-run at least one sibling example in the same feature family to catch copy-paste drift.
- If you add a new example for a public feature, verify the nearest README snippet still matches the example's constructor and params style.
- Keep the example's logging and return style consistent with nearby crates unless you are intentionally normalizing the whole cluster.
- When an example exercises a feature with special runtime needs, copy the closest working crate instead of composing dependencies from scratch.
