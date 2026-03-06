# Profile: Simplify

Look for opportunities to reduce complexity, merge work, and inline unnecessary helpers.

## Phase merging
- Can any adjacent phases be merged without losing independent verifiability?
- Are there phases with trivial scope (< 10 LOC) that should be absorbed into a neighbor?

## Inlining
- Are there single-use helper functions that should be inlined at the call site?
- Are there single-use types/interfaces that add naming overhead without clarity?
- Are there utility files with only one export?

## Complexity reduction
- Can any multi-step process be replaced with a simpler approach?
- Are there nested conditionals that could be flattened with early returns or guard clauses?
- Can any configuration be replaced with hardcoded values (if only one value is ever used)?

## LOC reduction
- Identify the three largest opportunities to reduce total lines of code without losing functionality.
- For each, estimate the LOC reduction and describe the simplification.
