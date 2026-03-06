# Profile: Code Quality

Focus exclusively on implementation quality. Ignore plan structure and formatting.

## Simplicity
- Are there unnecessary abstractions, wrapper layers, or indirection that do not earn their keep?
- Could the same result be achieved with less code or fewer files?
- Are new types/structs justified, or could existing ones be extended?

## DRY
- Is there duplicated logic that should be extracted into a single function?
- Are there copy-pasted blocks differing only in small details?

## Dead weight
- Are there unused imports, unreachable branches, or commented-out code?
- Are there parameters that are always passed the same value?

## Readability
- Would a new contributor understand this without extra context?
- Are names clear and descriptive? Is control flow straightforward?

## Error handling
- Are errors surfaced properly — no swallowed errors, no defensive overkill?
- Is error handling proportionate to actual failure modes?

## Interface design
- Functions with >5 parameters: group into a single config/options object.
- Config objects with >8 fields: break into logical sub-groups (e.g. `M { N: {a,b,c}, O: {d,e,f} }`).
- Flag long parameter lists in both plan phases and code review.

## Consistency
- Does new code follow existing codebase conventions for naming, structure, and patterns?
