# Known Pitfalls - anthropic-ai-sdk

anthropic-ai-sdk-specific recurring mistakes. Max 10 entries. For project-wide pitfalls, see root `docs/agent-memory/known-pitfalls.md`.

## Pitfalls

### Streaming calls fail unless the request opts into streaming

`create_message_streaming` rejects params unless `CreateMessageParams.stream == Some(true)`. If a streaming example or test forgets `.with_stream(true)`, the failure is local and immediate rather than an API-side error.

### Files API changes drift if the beta helper path is bypassed

Files endpoints depend on the `anthropic-beta` header and the beta-aware helpers in `client.rs`. Editing `files.rs` to use the normal JSON helpers drops the required header and silently changes request behavior.

### New domain errors must convert from strings

`client.rs` helper methods surface request failures, body-read failures, and JSON parse failures through `E: From<String>`. A new error enum without `From<String>` will not wire into the shared transport layer.

### Message batch limits are enforced with panic at construction time

`CreateMessageBatchParams::new()` panics above 100,000 requests. Tests or helpers that fuzz batch sizes need to guard the input first instead of expecting a recoverable `Result`.
