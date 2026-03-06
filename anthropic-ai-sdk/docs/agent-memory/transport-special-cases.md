---
scope: anthropic-ai-sdk
keywords: streaming, beta, multipart
last-updated: 2026-03-06
related-files: anthropic-ai-sdk/src/client.rs, anthropic-ai-sdk/src/messages.rs, anthropic-ai-sdk/src/files.rs, anthropic-ai-sdk/src/types/message.rs, anthropic-ai-sdk/src/types/files.rs, anthropic-ai-sdk/src/types/message_batches.rs
---

# Transport Special Cases

This topic captures the SDK flows that do not fit the default JSON request helper path.

## Streaming Messages

- `messages.rs::create_message_streaming` does not use `client.rs::post`; it builds the request directly so it can return an SSE stream instead of eagerly deserializing JSON.
- The method rejects params unless `CreateMessageParams.stream == Some(true)`. Callers and examples must opt into streaming with `.with_stream(true)`.
- Streaming response parsing depends on `eventsource-stream` over `response.bytes_stream()` and maps each event body into `StreamEvent`.
- Parse failures include the raw event payload in the error string. That is useful for debugging and noisy for exact string assertions.
- If a future streaming endpoint appears, copy the structure of `create_message_streaming` instead of forcing it through the JSON helpers.

## Beta Header Flows

- Files API calls must use the beta-aware helpers in `client.rs` so the `anthropic-beta` header is present on every request.
- `files.rs` currently uses the same `files-api-2025-04-14` header value across list, get, download, upload, and delete. Version bumps must stay synchronized across all five flows.
- JSON-returning beta endpoints should use `get_with_beta` or `delete_with_beta` rather than hand-wiring headers in a domain module.
- Binary-returning beta endpoints should use `send_request_with_beta_bytes` or `download_with_beta`.
- Multipart beta uploads must go through `upload_file_with_beta`; the normal JSON helpers cannot express the body shape.

## Parameter Invariants

- `ListFilesParams::limit()` clamps values into `1..=1000`, and `validate()` rejects simultaneous `before_id` and `after_id`.
- `files.rs` calls `validate()` before dispatch. If a new params type has similar invariants, validate in the domain impl so every caller benefits.
- `CreateMessageBatchParams::new()` panics above 100,000 requests. That invariant is enforced at construction time, not via `Result`.
- Message batch delete semantics are stricter than the helper shape suggests: the batch must finish or be canceled before deletion succeeds.
- Any new builder that can fail should prefer `Result` over `panic!` unless the crate already treats the invariant as impossible for normal callers.

## Response Handling

- `client.rs::send_request` and `send_request_with_beta` read the full response body into a string before deserializing.
- JSON parse errors therefore include the full response text, which is helpful for debugging and can produce large failure messages.
- The binary beta helper is the exception: it returns raw bytes on success and only reads text on non-success statuses.
- Upload helpers also read the full response text before deserializing, so upload response shape changes surface as parse failures instead of compile errors.
- If a future endpoint returns newline-delimited JSON or another streamed format, it needs a bespoke transport path instead of the generic helpers.
- Low-level helper changes affect every API family. Validate across more than one domain after editing them.

## Choosing the Transport Layer

- Use the plain JSON helpers when the endpoint returns a single JSON document and does not require beta headers.
- Use the beta JSON helpers when the endpoint is still gated by `anthropic-beta` but otherwise behaves like a normal JSON response.
- Use the bytes helper when success returns binary data and error paths still need human-readable body text.
- Use a bespoke streaming path when the response is evented or incremental; the shared helpers assume full-body buffering.
- Preserve the standard auth and version headers from `AnthropicClient` accessors whenever you build a manual request path.
