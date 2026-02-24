---
name: learn
description: >
  Capture and persist development learnings into CLAUDE.md and docs/learnings/ files. This skill is the
  guardian of institutional knowledge — it ensures hard-won insights survive beyond the current session.
  Use this skill during implementation (after fixing a tricky bug, discovering a gotcha, making an
  architectural decision), at the end of planning or brainstorming sessions, at the end of a feature,
  or whenever the user says "learn", "capture this", "remember this", "what did we learn", "update
  CLAUDE.md", "document this insight", or "find learnings". Also trigger proactively when you notice a
  learning moment during work — an unexpected behavior, a non-obvious solution, a pattern worth
  preserving — even if the user hasn't explicitly asked. If you just spent significant effort debugging
  something, or discovered something surprising about the codebase, that's a signal to activate this
  skill. Also use this skill when the user says "cleanup learnings", "organize learnings",
  "deduplicate", or "restructure docs" — it can audit and reorganize the entire learnings corpus.
---

# Learn — Institutional Knowledge Capture

Development knowledge compounds across sessions only if it's written down. This skill captures
gotchas, architectural decisions, patterns, and edge cases — then persists them where future
sessions will find them.

## Where Learnings Live

| Scope | Destination | What goes here |
|-------|-------------|----------------|
| **Project-wide** | `./CLAUDE.md` | Cross-cutting conventions, workflow rules, critical gotchas that affect multiple modules. Keep this lean — it's loaded every session. |
| **Module/topic** | `docs/learnings/<topic>.md` | Detailed learnings for a specific area (e.g., `database.md`, `testing.md`, `authentication.md`). New files created as new topics emerge. |
| **Universal** | `~/.claude/CLAUDE.md` | Patterns that apply to any project — language gotchas, tool configuration, general practices. |

When in doubt, prefer `docs/learnings/`. CLAUDE.md should stay compact.

## Before Writing Any Learning

This procedure applies every time, regardless of which mode triggered the capture:

1. **Pass the "next session" test** — Would knowing this make a future session meaningfully more productive? If not, skip it.
2. **Find the right file** — List `docs/learnings/` and check if an existing topic file covers this area. If not, create one with a descriptive name.
3. **Check for duplicates** — Grep the target file and CLAUDE.md for the key concepts. If the learning is already captured, either skip or refine the existing entry rather than adding a new one.
4. **Match the file's voice** — Read the target file. Respect its current structure, section headings, and tone. Append to the right section rather than dumping at the bottom.
5. **Keep it concise** — A two-line entry that captures the insight is better than a verbose block.

### New Topic File Structure

When creating a new file in `docs/learnings/`, start with only the sections that have content:

```markdown
# [Topic Name]

## Gotchas

### [Title]
[What happens, why, and how to handle it.]

## Patterns

### [Title]
[When to use it and why it works.]

## Decisions

### [Title]
Chose [X] over [Y] because [rationale]. Trade-off: [what was given up].
```

## Modes of Operation

### Proactive Nudges (During Work)

Watch for signals that something worth capturing just happened:

- A bug took significant investigation to diagnose
- An API or library behaved unexpectedly
- An approach didn't work and you had to pivot
- A non-obvious dependency or relationship was discovered
- A pattern emerged that solved a recurring problem
- An architectural trade-off was made with clear rationale

When you spot one, briefly surface it without interrupting flow:

> "That's worth capturing — [one-sentence summary]. Document now or at the end?"

If the user defers, include it in the checkpoint capture later.

### Checkpoint Capture (At Natural Boundaries)

Activate at transition points in the workflow:

- **End of brainstorming/design** — What constraints, trade-offs, or decisions emerged?
- **End of planning** — What assumptions were challenged during breakdown?
- **After a green phase** — Did the implementation reveal anything surprising?
- **End of a feature** — Review all accumulated knowledge.
- **Before context gets long** — Capture before compaction loses nuance.

Ask: **"What would have saved time if we'd known it at the start?"**

### Session Review (User-Invoked)

When the user says "find learnings" or "what did we learn", scan the conversation for:

- Corrections where an initial approach was wrong
- Surprises — behavior that wasn't expected
- Decisions with rationale worth preserving
- Patterns that worked well or failed

Present findings as a numbered list with one-line summaries. Ask the user which to persist
and where. Then follow the "Before Writing" procedure for each approved item. Show what was
added and where.

### Cleanup and Reorganize

When the user says "cleanup learnings", "organize learnings", or "deduplicate":

**Step 1 — Audit.** Read CLAUDE.md and every file in `docs/learnings/`. Build a mental map of
all captured knowledge.

**Step 2 — Identify issues.** Look for:
- **Duplicates**: Same insight appears in multiple places. Keep the best version in the most
  appropriate location, remove the rest.
- **Misplaced entries**: Module-specific learning sitting in CLAUDE.md (move to topic file),
  or cross-cutting concern buried in a topic file (promote to CLAUDE.md).
- **Stale entries**: Check against the current codebase — if a file, API, or pattern referenced
  in the learning no longer exists or has changed, flag it.
- **Consolidation opportunities**: Multiple similar entries (e.g., three related gotchas) that
  could become one clear pattern entry.
- **CLAUDE.md bloat**: If CLAUDE.md has grown beyond ~100 lines of learnings, identify entries
  to move to topic files.

**Step 3 — Propose.** Present a summary organized by action type (merge, move, remove, rewrite).
Include before/after snippets for rewrites so the user can judge quality.

**Step 4 — Execute after approval.** Make the changes. Show a final summary of what moved where.

## LEARNINGS.md — Temporary Scratch Pad

For larger features spanning multiple sessions, a temporary LEARNINGS.md in the project root
can accumulate rough notes as work progresses. Think of it as a staging area.

**Lifecycle:** Create at feature start → append informally as you go → merge into permanent
locations at feature end → delete the file.

The merge step is where quality matters: each entry gets filtered through the "Before Writing"
procedure and placed in the right `docs/learnings/` file or CLAUDE.md.
