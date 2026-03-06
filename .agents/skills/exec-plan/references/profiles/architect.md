# Profile: Architecture

Check conformance to project architecture, module boundaries, and established patterns.

## Module boundaries
- Does new code respect existing module/package boundaries?
- Are there imports that reach across layers (e.g., UI importing directly from data layer)?
- Is there logic placed in the wrong layer (business logic in controllers, presentation logic in models)?

## Dependency direction
- Do dependencies flow in the expected direction (e.g., outer layers depend on inner, not vice versa)?
- Are there circular dependencies between modules?
- Are there new coupling points that could be avoided?

## Pattern conformance
- Does new code follow the patterns already established in the codebase (e.g., repository pattern, service layer, middleware chain)?
- Are there inconsistencies in how similar problems are solved across the codebase?
- Does the plan introduce a new pattern where an existing one would work?

## Right-level abstraction
- Is code placed at the right level of the architecture (not too high, not too low)?
- Are shared utilities genuinely shared, or are they single-use code disguised as reusable?
