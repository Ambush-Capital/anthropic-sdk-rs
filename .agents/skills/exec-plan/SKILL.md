---
name: exec-plan
display_name: Exec Plan
invoke_prompt: "Use $exec-plan create <description> to generate a new execution plan, or $exec-plan review <path> to review an existing one."
description: Generate, review, and iterate on ExecPlans — self-contained execution plans for LLM agents. Produces both a Markdown source-of-truth and a rich themed HTML view with diagrams and charts. Supports create, review, update, implement, and verify sub-commands.
---

# Exec Plan

Generate, review, and iterate on ExecPlans. Each plan consists of two files: an MD file (source of truth for agents) and an HTML file (rich themed display for humans). The MD is always authoritative — the HTML is derived from it and must stay in sync.

## Input

`$ARGUMENTS` contains any text passed after the skill name at invocation time.

Parse `$ARGUMENTS` to determine the sub-command:

| Arguments | Action |
|-----------|--------|
| `create <description> [--theme <name>]` | Generate a new ExecPlan (MD + HTML) |
| `review [path] [--<profile>...]` | LLM-as-judge review of an existing plan |
| `update [path]` | Surgical edit of an existing plan |
| `implement [path]` | Execute a plan's milestones |
| `verify [path] [--<profile>...]` | Verify implementation matches plan |

If `$ARGUMENTS` starts with none of the sub-commands above, treat the entire argument as a description and default to `create`.

For `review`, `update`, `implement`, and `verify`: if no path is given, find the most recent `.md` file in `documentation/agent-plans/` by filename date prefix.

### Profile flags

For `review` and `verify`, parse `$ARGUMENTS` for flags matching `--<profile-name>`. Each flag maps to a file in `references/profiles/` (e.g. `--code-quality` loads `references/profiles/code-quality.md`). Multiple flags are allowed.

Available profiles: `code-quality`, `overengineer-check`, `simplify`, `testability`, `architect`.

Examples:
- `review --code-quality` — review using only the code-quality profile
- `verify --overengineer-check --simplify` — verify using both profiles
- `review path/to/plan.md --architect --testability` — path + multiple profiles

If profile flags are present, load only the specified profile file(s) as review criteria. Do NOT also load `references/review-checklist.md`.

If no profile flags are present, load `references/review-checklist.md` (default behavior).

If a flag does not match any file in `references/profiles/`, list the available profiles and ask the user to correct the name.

## Shared Rules

These apply to every sub-command:

1. **MD is source of truth.** All changes go to the MD file first. The HTML is then synced to match.
2. **Consistency is mandatory.** After any change to either file, verify that every section, phase, risk score, complexity score, decision, and progress item in the MD appears accurately in the HTML.
3. **PLANS.md governs the ExecPlan format.** If a `PLANS.md` file exists in the target repo, read it and follow its rules. The ExecPlan template in this skill extends (not replaces) the PLANS.md format.
4. **Ask, don't assume.** If anything is ambiguous or you face a decision you're unsure about, ask the user.

## Sub-command: `create`

### Step 1: Parse arguments

Extract the plan description from `$ARGUMENTS`. Check for an optional `--theme <name>` flag. Valid theme names are listed in `references/themes.md`.

If no theme is specified, pick one at random from the 10 available themes.

### Step 2: Research and clarify

1. If `PLANS.md` exists at the repo root, read it in full.
2. Read relevant codebase files to understand the context for the plan.
3. If anything is ambiguous — requirements, scope, approach, trade-offs — ask the user before proceeding. Do not make assumptions.

### Step 3: Generate the MD file

Read `references/execplan-template.md` for the skeleton.

The plan must be organized into specific implementation phases. Each phase needs:
- A clear scope description
- **Risk score**: Low / Medium / High (based on blast radius, reversibility, systems touched)
- **Complexity score**: 1-5 (based on LOC estimate, file count, domain knowledge needed)
- Dependencies on other phases
- Acceptance criteria for that phase

Include a Risk & Complexity Summary Table at the top of the Plan of Work section.

#### Specificity gate

Before moving to Step 4, verify every phase description passes these checks. If a phase fails any check, rewrite it until it passes.

1. **Named files** — Every file that will be created, modified, or deleted is listed by full repository-relative path. "Update the config" fails. "Modify `src/config/settings.ts`" passes.
2. **Named symbols** — Functions, methods, types, and interfaces are named explicitly. "Add a helper function" fails. "Add `parseProfileFlags(args: string[]): string[]` to `src/lib/args.ts`" passes.
3. **Diff-level detail** — For modifications to existing files, describe what to insert, replace, or remove and where. "Update the handler" fails. "In `handleRequest()` in `src/api/handler.ts`, replace the hardcoded timeout with `config.requestTimeoutMs`" passes.
4. **No weasel verbs** — "as needed", "appropriately", "properly", "relevant", "various" are banned in scope and step descriptions. Replace each with the specific thing.
5. **Concrete acceptance** — Every acceptance criterion names an observable output: a command and expected result, a UI state to observe, or a specific file/behavior to verify. "Verify it works" fails.

Write the MD file to: `documentation/agent-plans/<YYYY-MM-DD>-<slug>.md`

Where `<YYYY-MM-DD>` is today's date and `<slug>` is a short kebab-case identifier derived from the description (e.g., `2026-02-24-add-auth-middleware.md`). Create the `documentation/agent-plans/` directory if it does not exist.

### Step 4: Generate the HTML file

Read `references/themes.md` to get the CSS for the chosen theme. Read `references/html-template.html` for the HTML shell.

Convert the MD content into the HTML template:
- Replace `{{TITLE}}` with the plan title (the `#` heading)
- Replace `{{THEME_NAME}}` with the chosen theme name
- Replace `{{THEME_CSS}}` with the full CSS block for the chosen theme
- Replace `{{CONTENT}}` with the plan content converted to HTML elements

The HTML must include:
- All plan sections as styled HTML
- Risk/complexity badges (color-coded per score)
- Phase progress bars derived from the Progress section checkboxes
- Mermaid diagrams — always include a phase dependency flowchart and timeline; for plans that touch data models or multi-component flows, also include sequence diagrams (showing how components interact) and entity/data model charts (showing schema or struct relationships)
- Collapsible sections for Decision Log, Surprises & Discoveries, Artifacts
- A sticky sidebar table of contents

Write the HTML file to: `documentation/agent-plans/<YYYY-MM-DD>-<slug>.html` (same directory and slug as the MD).

### Step 5: Consistency check

Read both files. Verify every section heading, phase, risk score, complexity score, decision log entry, and progress item from the MD appears in the HTML.

### Step 6: Present to user

Show:
- Theme chosen
- MD file path
- HTML file path
- Plan summary (phases, overall risk/complexity)

## Sub-command: `review`

### Step 1: Load the plan

Read the MD file at the given path (or the most recent in `documentation/agent-plans/`). Also read the corresponding HTML file.

### Step 2: Review

If profile flags were specified, read each corresponding `references/profiles/<name>.md` file. Otherwise, read `references/review-checklist.md`. Evaluate the plan against every criterion in the loaded file(s).

Regardless of which file is loaded, always check these core dimensions:

**Simplicity**
- Is this over-engineered? Could any part be simplified?
- Are there unnecessary abstractions or excessive new types/structs?
- Could fewer phases accomplish the same goal?

**Correctness**
- Will this actually work? Is it reliable?
- Does it match the original requirements?
- Are edge cases addressed?

**Internal consistency**
- Do risk/complexity scores match the described work?
- Do phases reference correct dependencies (no circular, no missing)?
- Does the Progress section match what's actually done?
- Does the Decision Log reflect decisions visible in the prose?
- Do Concrete Steps match the Plan of Work?
- Are all terms of art defined?
- Are there contradictions between sections?

**MD/HTML consistency**
- Does every section in the MD appear accurately in the HTML?
- Are risk scores, phase descriptions, and progress items in sync?

### Step 3: Act on findings

Classify each issue by severity:
- **Minor**: fix silently in both MD and HTML
- **Medium**: fix in both MD and HTML, then present the fixes to the user
- **Major** (>40% structural change): stop immediately and present findings to the user for discussion — do NOT make changes

### Step 4: Update living sections

Add entries to the Decision Log for any decisions made during review. Update the Changelog at the bottom of the MD.

### Step 5: Sync HTML

After all MD edits, sync the HTML to match.

---

## Sub-command: `update`

This is a **surgical** operation. Preserve the plan's existing structure. Only change what the feedback requires.

### Step 1: Understand the feedback

Read the user's feedback from `$ARGUMENTS` or the conversation. Identify exactly which sections of the MD need changes.

### Step 2: Surgical MD edits

1. Read the full MD file.
2. Edit only the sections that need to change. Do NOT rewrite sections that aren't affected by the feedback.
3. Preserve all headings, phase organization, and untouched content exactly as-is.
4. Add an entry to the Changelog describing what changed and why.
5. Add an entry to the Decision Log if the update involved a decision.

### Step 3: Sync HTML

Update only the corresponding sections in the HTML. Do NOT regenerate the entire HTML from scratch unless the changes are structural (adding/removing phases, changing the theme).

### Step 4: Consistency check

Verify that the MD and HTML match after the edits. Every section, score, and decision in the MD must appear accurately in the HTML.

### Step 5: Present changes

Show the user a summary of what changed — not the whole plan. List the sections modified and the nature of each change.

---

## Sub-command: `implement`

### Step 1: Load the plan

Read the plan MD in full.

### Step 2: Execute phased milestones

Follow the plan's phases in order. For each phase:

1. Read the phase's scope, concrete steps, and acceptance criteria.
2. Implement the changes described.
3. Follow these code principles:
   - Write simple, readable, human-understandable code
   - Reuse existing objects and helpers — add to existing modules rather than creating new ones
   - Minimize creation of new structs/types — only create when genuinely necessary
   - Add helpers to the right namespaces/modules, not scattered new files
   - No over-engineering, no unnecessary abstractions
   - Good error messages that help humans debug
4. Run validation for that phase (tests, build, manual verification).
5. Update the Progress section in the MD with checkboxes and timestamps.
6. If you discover something unexpected, add it to Surprises & Discoveries.
7. If you make a design decision, add it to the Decision Log.

### Step 3: Sync HTML

After each phase (or at natural stopping points), sync the HTML to reflect updated Progress, Decision Log, and Surprises & Discoveries.

---

## Sub-command: `verify`

### Step 1: Load the plan

Read the plan MD in full.

### Step 2: Compare implementation against plan

For each phase and its acceptance criteria:
1. Check that the described behavior exists and works.
2. Check that no requirements were missed or deviated from.

### Step 3: Code quality review

If profile flags were specified, read each corresponding `references/profiles/<name>.md` file and use those criteria in addition to the review below.

Go beyond spec compliance. Read the actual implementation code and critically evaluate:

1. **Simplicity** — Could any part be simpler? Are there unnecessary abstractions, wrapper layers, or indirection that don't earn their keep? Could the same result be achieved with less code?
2. **DRY** — Is there duplicated logic that should be extracted? Are there copy-pasted blocks that differ only slightly?
3. **Dead weight** — Are there unused imports, unreachable branches, commented-out code, or parameters that are always the same value?
4. **Right-sizing** — Are new files/modules/types justified, or could the code live in an existing module? Are there single-use helpers that should be inlined?
5. **Readability** — Would a new contributor understand this without extra context? Are names clear? Is control flow straightforward or needlessly nested?
6. **Error handling** — Is error handling proportionate? No swallowed errors, but also no defensive overkill for things that can't fail.
7. **Consistency** — Does the new code follow the conventions already established in the codebase (naming, structure, patterns)?

For each issue found, classify by severity:
- **Nitpick**: Note it but don't fix (e.g., minor naming preference).
- **Improvement**: Fix it directly — the code works but could be meaningfully better.
- **Problem**: Something is wrong or fragile — fix it, or if it requires a design decision, ask the user.

### Step 4: Act on findings

- Fix all **Improvement** and **Problem** items (unless a Problem requires a design decision — ask the user).
- Present a summary of all changes made and nitpicks noted.

### Step 5: Update Outcomes & Retrospective

Write a summary comparing the implementation against the original purpose. Include:
- What was achieved and what gaps remain.
- A "Code Quality Notes" subsection listing improvements made and any remaining nitpicks.
- Lessons learned.

### Step 6: Sync HTML

Update the HTML to reflect the completed Outcomes & Retrospective and any final Progress updates.

---

## Constraints

1. Always create the `documentation/agent-plans/` directory if it does not exist.
2. Never modify source code outside of the plan files during `create`, `review`, or `update` sub-commands.
3. The `implement` sub-command modifies source code according to the plan.
4. The `verify` sub-command may fix minor code deviations.
5. All file paths in plans must be repository-relative.
