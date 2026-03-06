# Profile: Over-Engineering Check

Hunt specifically for over-engineering. Ask "does this need to exist?" about every new abstraction.

## Unnecessary abstractions
- Are there wrapper functions that just forward arguments to another function?
- Are there classes/types that could be plain functions or config objects?
- Are there interfaces with only one implementation?

## Excessive structure
- Could fewer phases accomplish the same goal?
- Are there phases that exist only for "cleanliness" rather than functional necessity?
- Are there new files/modules that could live in existing ones?

## Gold-plating
- Are there features or safeguards beyond what was requested?
- Are there "future-proofing" abstractions for requirements that do not exist?
- Is there configuration for things that will only ever have one value?

## Right-sizing test
For each new type, file, or abstraction introduced, answer: "What breaks if I inline/remove this?" If nothing breaks, it should not exist.
