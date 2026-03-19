---
name: permission-audit
description: >
  Analyze the permission-reviewer hook log to find recurring patterns that force user approval,
  then recommend actionable rules to reduce permission noise. Use this skill whenever the user says
  "audit permissions", "permission audit", "reduce permission prompts", "why do I keep getting asked",
  "optimize permissions", "permission report", or wants to understand what the permission hook is
  blocking and how to streamline approvals for a project.
user_invocable: true
---

# Permission Audit

Analyze permission-reviewer decisions for a project, identify recurring patterns that force manual
approval, and produce concrete recommendations — either deterministic allow rules for
`settings.local.json` or NLP context for `.claude/permissions.md`.

## Workflow

### Step 1: Gather Data

Collect permission decisions for the current project.

```bash
# Get project name from cwd (matches how permission-reviewer derives it)
PROJECT_SLUG=$(pwd | sed 's|/.worktrees/.*||' | rev | cut -d'/' -f1-2 | rev)

# New-format logs (with [project] tags)
/Users/vertexcover/Projects/dotfiles/claude/permission-reviewer.sh --report "$PROJECT_SLUG"

# Fallback: old-format logs (before [project] tags were added) — grep by cwd path
grep "$(pwd)" /tmp/permission-reviewer.log | grep -E '(DECISION: (ask|deny)|GUARD|SKIP)' | grep -v 'requires user interaction'
```

Run both. The new-format report will be empty initially until enough new logs accumulate.

### Step 2: Read Existing Config

Read these files if they exist — avoid recommending rules that are already in place:

- `.claude/settings.local.json` — project-level deterministic allow/deny rules
- `.claude/permissions.md` — project-level NLP context for the reviewer
- Read the global settings at `/Users/vertexcover/Projects/dotfiles/claude/settings.json` to know what's already allowed globally

### Step 3: Analyze Patterns

Group log entries by tool + command shape. For Bash tools, extract the command prefix
(first 2-3 words). Count frequency per pattern.

**Classify each pattern into one of three buckets:**

#### Bucket A: `settings.local.json` — Deterministic allow rules
For commands that are always safe in this project and can be expressed as a prefix match.

Format: `Bash(command-prefix:*)`

Good candidates:
- Package manager commands: `Bash(pnpm:*)`, `Bash(npm test:*)`, `Bash(cargo:*)`
- Build/dev tools: `Bash(make:*)`, `Bash(docker compose:*)`
- Project-specific CLI tools: `Bash(turbo:*)`, `Bash(nx:*)`
- Git operations for this project: `Bash(git add:*)`, `Bash(git commit:*)`
- MCP read operations: specific `mcp__*` tool names

#### Bucket B: `.claude/permissions.md` — NLP context for reviewer
For patterns that need LLM judgment but can be guided with project context.

Good candidates:
- "This project uses pnpm — approve all pnpm commands"
- "git worktree remove is routine in this project's workflow"
- "The `scripts/` directory contains safe dev utilities"
- "Approve `make db-migrate` — it's idempotent and dev-only"

#### Bucket C: Keep asking — Correctly flagged
For patterns that should continue requiring user approval.

These are always Bucket C (never recommend auto-approval):
- DENY decisions (credential access, .env files, obfuscated commands)
- Force push / push to main/master
- Production database operations
- External service writes (MCP create/update/delete)
- `rm -rf` outside safe targets

### Step 4: Present Recommendations

Present findings grouped by bucket. For each pattern show:
- The command/tool pattern
- How many times it appeared in the log
- Which bucket it belongs to and why

**Format for Bucket A recommendations:**

```json
{
  "permissions": {
    "allow": [
      "Bash(pnpm:*)",
      "Bash(docker compose up:*)",
      "Bash(docker compose down:*)"
    ]
  }
}
```

**Format for Bucket B recommendations:**

```markdown
- Approve all pnpm commands — this is the project's package manager
- `git worktree remove` and `git branch -D` are part of the normal worktree workflow
- `make db-seed` is idempotent and only affects the dev database
```

**Format for Bucket C (keep as-is):**

Show the patterns with a brief explanation of why they should keep requiring approval.

### Step 5: Apply on Approval

Use `AskUserQuestion` to let the user select which recommendations to apply.

- **Bucket A:** Merge into `.claude/settings.local.json` (create if it doesn't exist).
  Preserve existing entries. Add new allow rules to the `permissions.allow` array.
- **Bucket B:** Append to `.claude/permissions.md` (create if it doesn't exist).
  Keep existing content. Add new entries at the end.

After applying, remind the user to clear the permission cache:
```bash
rm -rf /tmp/permission-reviewer-cache
```

## Important Rules

1. **Never recommend auto-approving DENY patterns** — these are security boundaries.
2. **Never recommend auto-approving production database access** — always ask.
3. **Never recommend auto-approving force push or push to main/master.**
4. **Prefer `settings.local.json` over `permissions.md`** when the pattern is deterministic — it's faster (no LLM call needed) and more reliable.
5. **Show frequency counts** — patterns that appear once may not be worth adding rules for.
6. **Deduplicate** — check existing config before recommending.
