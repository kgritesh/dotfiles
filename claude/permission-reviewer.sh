#!/bin/bash
# Borrowed from https://gist.githubusercontent.com/stevenc81/efc7b04f4293f429a57758f871962890/raw/f9ef9f2f9d858d4f8d5da253dacc6abcf81bafd9/permission-reviewer.sh
set -euo pipefail

LOG_FILE="/tmp/permission-reviewer.log"
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

REVIEWER_MODEL="claude-opus-4-5-20251101"

# --- Read stdin ---
HOOK_INPUT=$(cat)
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$HOOK_INPUT" | jq -c '.tool_input // {}')
CWD=$(echo "$HOOK_INPUT" | jq -r '.cwd // empty')

# Malformed input -> passthrough
if [ -z "$TOOL_NAME" ]; then
  log "SKIP: malformed input (no tool_name)"
  exit 0
fi

log "HOOK FIRED: tool=$TOOL_NAME cwd=$CWD"

# --- Always ask user for MCP write operations on external services ---
# These should never be auto-approved; fall through to manual approval.
if echo "$TOOL_NAME" | grep -qE '^mcp__.*(create|update|delete|add_message|write|push|merge|assign|move|duplicate)'; then
  log "SKIP: MCP write operation, falling through to manual approval"
  exit 0
fi

# --- Truncate large tool input (keep first 4000 chars) ---
TRUNCATED_INPUT=$(echo "$TOOL_INPUT" | head -c 4000)

# --- Build reviewer prompt ---
REVIEWER_PROMPT="You are a security reviewer for an AI coding assistant. Review this tool call and decide: approve, ask, or deny.

TOOL: ${TOOL_NAME}
CWD: ${CWD}
INPUT: ${TRUNCATED_INPUT}

APPROVE if:
- Standard dev commands (npm test/install/build, git operations, make, cargo, etc.)
- Reading/writing/editing files within the project directory
- Running linters, formatters, type checkers, test suites
- Standard CLI tools used non-destructively
- curl/wget GET requests to known/public URLs
- General purpose commands that don't touch credentials or sensitive data
- 'source .env' or '. .env' commands (loading env vars into shell is safe)
- Moving .env files with 'mv' (relocating is allowed)
- git add of already-tracked modified files

DENY (hard block, no override) ONLY for truly dangerous operations:
- Accessing or exfiltrating credentials/secrets (~/.ssh, ~/.aws, tokens, API keys)
- Piping secrets or credentials to external services
- Mass/recursive deletion outside safe targets (node_modules, dist, build, .cache)
- Obfuscated commands designed to hide intent (base64 decode | bash, eval of encoded strings)
- curl | bash patterns (downloading and executing remote scripts)
- Reading .env files (cat, less, more, head, tail, grep, rg, ag, find targeting .env)
- Writing/editing .env files (>, >>, sed -i, tee, nano, vim, echo/printf to .env)
- Blanket git staging: 'git add -A', 'git add --all', 'git add .', 'git add *', 'git add ../'

When DENYING .env access, include this in your reasoning:
  Use env-safe CLI instead: env-safe list, env-safe list --status, env-safe check KEY, env-safe count, env-safe validate.
  To use env vars in commands: source .env && <command>

When DENYING blanket git add, include in your reasoning:
  Stage specific files by name instead of using blanket patterns.

ASK (let the user decide) for:
- Commands you're not fully sure about
- curl/wget POST requests
- sudo or privilege escalation
- Force pushing to remote repos
- Destructive database operations
- git add of untracked/new files (user should confirm which new files to stage)
- Anything not clearly safe but not clearly credential/leak/mass-deletion risk

When in doubt, ask -- NOT deny.

Respond with ONLY a JSON object: {\"decision\":\"approve\" or \"ask\" or \"deny\", \"reasoning\":\"brief explanation\"}"

# --- Call reviewer ---
REVIEWER_OUTPUT=""
if REVIEWER_OUTPUT=$(env -u CLAUDECODE "$HOME/.claude/local/claude" -p \
  --output-format json \
  --model "$REVIEWER_MODEL" \
  --tools "" \
  --no-session-persistence \
  --dangerously-skip-permissions \
  "$REVIEWER_PROMPT" 2>/dev/null); then
  :
else
  log "REVIEWER CALL FAILED, falling through to manual approval"
  exit 0
fi

# --- Parse response ---
RESULT_TEXT=$(echo "$REVIEWER_OUTPUT" | jq -r '.result // empty' 2>/dev/null)
if [ -z "$RESULT_TEXT" ]; then
  RESULT_TEXT="$REVIEWER_OUTPUT"
fi

# Try direct jq parse, then strip markdown fences as fallback
CLEAN_JSON="$RESULT_TEXT"
if ! echo "$CLEAN_JSON" | jq -e '.decision' >/dev/null 2>&1; then
  CLEAN_JSON=$(echo "$RESULT_TEXT" | sed '/^```/d')
fi

DECISION=$(echo "$CLEAN_JSON" | jq -r '.decision // empty' 2>/dev/null)
REASONING=$(echo "$CLEAN_JSON" | jq -r '.reasoning // "No reasoning provided"' 2>/dev/null)

# --- Emit hook decision ---
log "DECISION: $DECISION | REASONING: $REASONING"
if [ "$DECISION" = "approve" ]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
elif [ "$DECISION" = "deny" ]; then
  jq -n --arg reason "$REASONING" \
    '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"deny","message":$reason}}}'
else
  # "ask" or unrecognized -> fall through to manual approval
  exit 0
fi

exit 0
