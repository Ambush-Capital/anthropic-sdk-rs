# Review Checklist

Use this checklist when running the `review` sub-command. Evaluate the plan against every criterion below.

## 1. Simplicity

- Is the plan over-engineered? Could the same outcome be achieved with fewer phases, fewer files, or a simpler approach?
- Are there unnecessary abstractions — new types, interfaces, or wrapper layers that don't carry their weight?
- Does the plan create new structs/types when existing ones would work?
- Are there phases that could be merged without losing clarity?
- Does the plan propose creating new helper files/modules when adding to existing ones would be simpler?
- Is there gold-plating — features or safeguards beyond what was requested?

## 2. Correctness

- Does the plan match the original requirements? Re-read the purpose and compare.
- Will the described approach actually work? Trace through the steps mentally.
- Are there edge cases or failure modes not addressed?
- Are the concrete steps correct — right commands, right paths, right expected outputs?
- Are the acceptance criteria specific and verifiable? Could a novice tell success from failure?
- Are risk scores realistic? (A cross-cutting change marked "Low" is a red flag.)
- Are complexity scores realistic? (A 500 LOC change scored "1" is a red flag.)
- Are LOC estimates in the right ballpark?

## 3. Internal Consistency

Check that sections agree with each other:

- **Risk/complexity vs. work described**: Do the scores match what the phase actually entails?
- **Phase dependencies**: Are they correct? No circular dependencies? No missing dependencies? Does each phase only depend on phases that come before it?
- **Progress vs. reality**: Does the Progress section accurately reflect what has actually been done? No checked items for work not yet completed?
- **Decision Log vs. prose**: Are decisions mentioned in narrative sections also recorded in the Decision Log? Are there Decision Log entries with no corresponding context in the plan?
- **Concrete Steps vs. Plan of Work**: Do the commands and edits described in Concrete Steps match what the Plan of Work describes?
- **Acceptance criteria vs. purpose**: Do the acceptance criteria, when met, actually fulfill the stated purpose?
- **Terms consistency**: Is every term of art defined on first use? Are terms used consistently (not renamed mid-document)?
- **File paths**: Are all file paths repository-relative and consistent across sections?

## 4. MD/HTML Consistency

- Does every section heading in the MD appear in the HTML?
- Are risk and complexity scores identical in both files?
- Are phase descriptions identical in both files?
- Are Progress checkboxes in the same state in both files?
- Are Decision Log entries identical in both files?
- Does the Changelog in the MD have entries not reflected in the HTML (or vice versa)?

## 5. Completeness

Required sections (all must be present and substantive — not just headers):

- Purpose / Big Picture
- Progress
- Surprises & Discoveries
- Decision Log
- Outcomes & Retrospective
- Context and Orientation
- Plan of Work (with Risk & Complexity Summary Table)
- Concrete Steps
- Validation and Acceptance
- Idempotence and Recovery
- Artifacts and Notes
- Interfaces and Dependencies
- Changelog

## 6. Self-Containment

- Could a novice with only this file and the repo implement the plan end-to-end?
- Are there references to external docs, blogs, or prior plans that aren't checked into the repo?
- Is domain knowledge assumed that isn't explained in the Context section?
- Are there "as discussed" or "as agreed" references without the actual content?
