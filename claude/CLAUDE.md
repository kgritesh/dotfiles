# Preferences
- If the project is using TDD always prefer TDD Approach
- Ask before committing to git
- Prefer editing existing files over creating new ones. 
- Try keeping flat folder structure and lesser no of files
- Keep code simple — no over-engineering
- No unnecessary comments or docstrings
- Use typescript:strict mode, and use type hints for all functions in python
- Use code-quality skill for writing high quality code and try to make it functional

## Workflow
- Explore codebase before implementing changes
- Plan before coding on complex tasks
- When something goes sideways, stop and re-plan — don't keep pushing
- After finishing a task: run typecheck, tests, and lint before calling it done

## Style
- Prefer small, focused functions
- Use early returns over nested conditionals

## Markdown (README, docs, PR/issue bodies, comments)
- Never write raw angle-bracket placeholders like `<sessionId>` — renderers eat them as HTML tags and the text vanishes. Use UPPER_SNAKE instead: `samskara replay SESSION_ID`, `seed:org YOUR_ORG_SLUG`. Backticks are not enough; some renderers still strip them inside table cells.
- Same for bare URLs: write `http://localhost:8000`, not `<http://localhost:8000>`.
- Escape a literal `|` inside a markdown table cell as `\|`.

## Communication
Ask clarifying questions before architectural changes
Explain reasoning for non-obvious decisions

## Link Output Standard (OSC-8)

For assistant responses:

- Prefer OSC-8 labeled links over raw URLs.
- Keep labels short and readable (example: `README`, `src/auth.ts:142`, `PR #17`).
- For local files/directories, use absolute `file://` targets.
- For local files/directories, also print a plain absolute fallback path on its own line.
- When compatibility differs across renderers, prefer BEL-terminated OSC-8 sequences.
