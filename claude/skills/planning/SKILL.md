---
name: planning
description: >
  Implementation planning for features, design documents, and multi-step tasks. Use this skill
  whenever you need to create an implementation plan before writing code — whether from a design
  document, a feature request, a bug fix, or any non-trivial task. Trigger when the user says
  "plan", "create a plan", "implementation plan", "break this down", "how should we implement",
  or when transitioning from brainstorming/design to implementation. Also trigger when the user
  provides a design document and wants to move to execution, or when a task clearly needs
  decomposition before coding begins. This skill bridges the gap between understanding a problem
  (brainstorm skill) and executing it (tdd skill). If no brainstorm/design doc exists and the
  feature is non-trivial, suggest brainstorming first — but don't block on it for smaller features.
  Also trigger when the user wants to update an existing plan using @fix tags.
---

# Implementation Planning

Produces actionable implementation plans as a folder of documents — one overview and
one file per phase. Each phase is a logical feature or capability. The folder structure
lets you work on early phases while refining later ones in parallel sessions.

**Announce at start:** "Using the planning skill to create an implementation plan."

## Plan Mode

**Call `EnterPlanMode` at the very start of planning.** Plan mode enables codebase
exploration (Read, Glob, Grep) while preventing premature code changes (Edit, Write
are disabled). This is exactly what planning needs — deep exploration without
accidentally implementing anything.

Write the plan documents during plan mode. When the plan is ready for user review,
call `ExitPlanMode` to present plan.md for approval. If the user requests changes,
continue in plan mode and call `ExitPlanMode` again when revisions are ready.

**Flow:** `EnterPlanMode` → Explore & Plan (Steps 1-4) → `ExitPlanMode` for approval

**Plan output:**
```
docs/plans/<feature-name>/
├── plan.md          # Overview — what each phase achieves
├── phase-1.md       # First logical feature
├── phase-2.md       # Second logical feature
└── ...
```

**For small, obvious changes** (single file, clear fix): skip planning, go straight to TDD.

---

## The Planning Process

### Step 1: Understand the Input

The input is either a **design document** or a **feature description**.

**If a design document exists:**
- Read it thoroughly — requirements, chosen approach, decisions, edge cases
- Note open questions or assumptions that affect implementation

**If working from a feature description:**
- Ask clarifying questions (batch 2-3 at a time)
- Identify acceptance criteria and scope boundaries

**Goal:** What are we building, what are the acceptance criteria, what's already decided?

### Step 2: Explore the Codebase

Build understanding of existing code before planning changes. Use subagents in parallel
to explore multiple areas simultaneously:

1. **Find similar patterns** — existing endpoints, background tasks, models as templates
2. **Identify touch points** — which files change, which are new, trace the data flow
3. **Understand test patterns** — how similar features are tested, what fixtures exist
4. **Check existing infrastructure** — shared utilities, base classes, configurations
5. **Identify dependencies** — what depends on what, what can run in parallel

Record findings — they go into plan.md's Codebase Context section.

### Step 3: Design the Phases

Each phase is a **logical feature or capability** — a coherent piece of functionality
that makes sense on its own. A phase typically follows one TDD cycle (RED-GREEN-REFACTOR)
resulting in one commit. Occasionally a complex phase may need multiple TDD cycles, each
with its own commit — but this should be rare. If a phase needs many cycles, it's
probably two features and should be split.

**Phase design:**
- Delivers a recognizable capability: "user registration," "rate limiting," "report generation"
- Has clear done criteria
- Leaves codebase in a working state with all tests passing
- Mark phases that can run in parallel (no dependencies on each other)

### Step 4: Write the Plan Documents

Create the folder and write all documents. Call `ExitPlanMode` to present plan.md
to the user for approval before finalizing phase files.

---

## plan.md Format

The overview is concise — what each phase delivers and how they relate. No
implementation details. See `references/plan-template.md` for annotated example.

```markdown
# Plan: [Feature Name]

> **Source:** [Design doc link or "Feature request"]
> **Created:** YYYY-MM-DD
> **Status:** planning | in-progress | complete

## Goal

[One sentence: what this plan delivers when complete]

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Codebase Context

### Existing Patterns to Follow
- **[Pattern]**: `path/to/example.py` — [brief description]

### Test Infrastructure
- Test runner, fixtures, factories, run command

## Phases

| # | Phase | Status | Depends On |
|---|-------|--------|------------|
| 1 | [What phase 1 delivers] | pending | — |
| 2 | [What phase 2 delivers] | pending | Phase 1 |

## Phase Dependency Graph

Phase 1 --> Phase 2 --> Phase 3
```

---

## phase-N.md Format

Each phase file describes what to build, which files to touch, and includes code
for anything non-obvious. The `tdd` skill handles the RED-GREEN-REFACTOR mechanics
during execution.

```markdown
# Phase N: [What This Phase Delivers]

> **Status:** pending | in-progress | complete
> **Depends on:** Phase X (or "none")

## Overview

[What capability exists after this phase that didn't before. Short paragraph.]

## Implementation

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py` — [what changes]
- Test: `tests/exact/path/to/test_file.py`

**Pattern to follow:** `path/to/similar_feature.py`

**What to test:**
- [Key behavior 1 the test should assert]
- [Key behavior 2]
- [Edge case worth calling out]

**What to build:**
[Describe the implementation. Reference the pattern file for straightforward parts.
Include code for complex/non-obvious parts — algorithms, tricky integrations,
business rules that could easily be gotten wrong.]

**Commit:** `feat(scope): description`

## Done When

- [ ] Tests pass for [key behaviors]
- [ ] Existing tests still pass
- [ ] [Any phase-specific verification]
```

### When to include code in a phase

Include code when the logic is non-obvious, the algorithm matters, the business rule
is complex, or the pattern diverges from codebase conventions. Skip code when a
reference to "follow the pattern in `path/to/example.py`" is sufficient — the TDD
cycle will produce the right code naturally.

---

## @fix Tags

Annotate phase files with `@fix` tags to mark what needs changing. The agent reads
the tags, applies changes, and removes them.

**Format:** `<!-- @fix: description of what needs to change -->`

Place directly above the content that needs updating.

**Examples:**
```markdown
<!-- @fix: use argon2 instead of bcrypt — it's already a project dependency -->
Hash the password with bcrypt before storing.

<!-- @fix: this phase is too large — split webhook delivery into its own phase -->
## Overview
This phase implements notifications: email, SMS, and webhook delivery.
```

When processing: collect all `@fix` tags, summarize changes to user, apply them,
remove tags. If fixes change phase structure, update plan.md too.

---

## Integration with Other Skills

**From brainstorm:** Read the design doc, skip Step 1 (already covered), focus on
codebase exploration and phase design.

**To execution:** After plan approval, work through phases in dependency order.
Load each phase-N.md, use the `tdd` skill for RED-GREEN-REFACTOR, commit after
each cycle. Update phase status as they complete. User can say "implement through
phase 3" to set a stopping point.

**Parallel sessions:** Session A implements phases 1-2 while Session B refines
phase-3.md and phase-4.md with `@fix` tags or direct edits.

**Tasks:** Create one task per phase with dependency relationships matching plan.md.
Update status as phases complete.
