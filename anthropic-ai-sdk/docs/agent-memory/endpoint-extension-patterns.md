---
scope: anthropic-ai-sdk
keywords: endpoints, traits, client
last-updated: 2026-03-06
related-files: anthropic-ai-sdk/src/lib.rs, anthropic-ai-sdk/src/client.rs, anthropic-ai-sdk/src/messages.rs, anthropic-ai-sdk/src/models.rs, anthropic-ai-sdk/src/message_batches.rs, anthropic-ai-sdk/src/admin_client.rs, anthropic-ai-sdk/src/types/mod.rs
---

# Endpoint Extension Patterns

This topic records the cross-file rules that matter when adding or reshaping SDK API surface.

## Module Split

- Keep endpoint traits, request and response types, and error enums under `src/types/`.
- Keep `AnthropicClient` impl blocks that hit HTTP endpoints in the sibling top-level module such as `messages.rs`, `models.rs`, `message_batches.rs`, `admin_client.rs`, or `files.rs`.
- Treat `client.rs` as transport infrastructure. It should provide reusable HTTP plumbing, not endpoint-specific path knowledge.
- Add new top-level modules to `src/lib.rs` so downstream crates can import them.
- Prefer extending an existing domain module before creating a new one when the API path shares auth model and error shape.

## Error and Constructor Contract

- Domain error types must implement `From<String>` because the shared helpers in `client.rs` convert transport, body-read, and JSON parse failures into strings.
- Client construction is generic over the target domain error type: `AnthropicClient::new::<MessageError>(...)`, `AnthropicClient::new::<ModelError>(...)`, or `AnthropicClient::new_admin::<AdminError>(...)`.
- Decide the concrete error type before wiring examples or docs for a new domain; constructor signatures depend on it.
- Preserve the split between request failures and API-body failures inside each domain error enum when possible; current modules use separate variants.
- Reuse `new_admin` only for organization-scoped endpoints. Do not add a second admin transport path unless auth semantics actually diverge.

## Request Helper Usage

- Default to `AnthropicClient::{get, post, delete}` for JSON endpoints that return JSON bodies.
- Keep path formatting at the call site in the domain module so endpoint ownership stays obvious.
- Use `Option::<&()>::None` when a helper call needs an explicit empty query type; this is the existing pattern for singular GET and DELETE requests.
- Validate or normalize params before dispatch when the request type has client-side invariants. `files.rs` currently does this through `params.validate()?`.
- Put limit clamping or cursor validation in the params type rather than in examples.

## Admin Domain Shape

- Admin APIs currently share one `AdminClient` trait and one `admin_client.rs` impl even though their types are split across `types/admin/*`.
- Preserve that split when adding admin features: namespace types by feature, keep transport centralized unless a separate client surface is necessary.
- Admin paths consistently live under `/organizations/...`; new admin examples and docs should match that prefix.
- Workspace-member APIs are nested under workspace paths rather than a separate root resource; follow the existing path structure for sibling operations.

## Export and Follow-Through

- After adding or moving public types, confirm the import paths used in examples and README snippets still compile.
- `anthropic-ai-sdk/README.md` is the human-facing SDK doc surface. Update it when a public API change affects common usage.
- Plan the matching example crate in `../examples/` when you add a new public feature; the repo uses examples as practical validation.
- If the new endpoint depends on Anthropic or Claude docs, start from `documentation/library-docs.md` before shaping the Rust surface.

## Validation Expectations

- Run `cargo check --workspace` after changing public imports or shared params types; the examples are the fastest downstream compatibility check.
- If you edit `client.rs`, validate at least one regular JSON domain and one special-case domain such as Files or streaming messages.
- If you change builder-style params, update at least one example that demonstrates the affected shape instead of relying on doc comments alone.
- Keep the SDK README and an example crate aligned on the same constructor and import style so users do not see two competing entry paths.
