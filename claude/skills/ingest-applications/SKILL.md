---
name: ingest-applications
description: Ingest new AI Engineer applications from Gmail into the Notion Hiring Pipeline. Discovers application emails not yet in Notion, downloads attached resume PDFs, extracts GitHub/LinkedIn/portfolio links from email body and resume, uploads resume to Notion, creates the candidate page with Score + Recommendation + Score Reason + Profile Summary block. Use this skill whenever the user asks to "process new applications", "ingest new candidates", "check Gmail for new resumes", "score new applicants", "import recent applications", or runs this on a /loop interval. Also use when the user mentions the Hiring Pipeline, Vertexcover Labs hiring, or wants to pull the latest Gmail applications into Notion, even if they don't explicitly say "ingest" or "skill".
---

# Ingest AI Engineer Applications

This skill turns an inbox of fresh AI Engineer applications into reviewable Notion entries with scores and reasoning, ready for the user to review.

It is meant to be re-run periodically (typically via `/loop 30m ingest new applications` or manually after a recruiting push). Each run is incremental — it only processes Gmail threads whose sender email is NOT already on a Notion candidate page.

## When to invoke

Trigger on user prompts like:
- "Process new applications from Gmail"
- "Check for new AI Engineer applications"
- "Ingest the latest resumes into Notion"
- "Score and add new applicants"
- A `/loop` schedule that wants this run periodically

Do NOT invoke for:
- Updating an already-scored candidate (use direct Notion edits)
- Sending accept/reject emails or changing a candidate's Status
- Bulk re-scoring of existing entries (use a separate one-off script)

## What the skill does

The flow is split into two stages — a deterministic discovery script and a model-driven scoring + page-creation step. This separation exists so the scoring step (which involves judgment) can use the full rubric from `references/scoring_criteria.md`, and so the Profile Summary appears as the FIRST body block in Notion (which only works if the page is created with the block already in its `children` array — the REST API can't insert at the top of an existing page).

### Stage 1: Discovery (deterministic, scripted)

```bash
node scripts/discover_new.mjs
```

This:
1. Loads existing emails AND existing candidate names from the Hiring Pipeline data source (dedupe by both — same person re-applying from `name@gmail.com` and `name@school.edu` is caught by name).
2. Searches Gmail for recent application threads in the last 14 days. The subject filter is broad (`AI Engineer` / `application` / `apply` / `vertexcover` / `vertex` / `engineer` / `resume`) so it catches applications that don't say "AI Engineer" verbatim (e.g. "Career Opportunities at Vertex", "Software Engineer Interested in AI Systems"). **The fetch pages deep (`SEARCH_MAX=500`, not 100)** — the old 100-cap silently truncated the oldest in-window applications when the window held >100 matches, which is exactly where un-ingested candidates hid. Noise that the broad subject pulls in (calendar invites, Notion/Slack/SaaS notifications, bank/invoice mail) is dropped by `NOISE_SENDERS` (sender domains) and `NOISE_SUBJECT` (e.g. "Invitation:", "Tax Invoice", "Transaction alert"). Generic mass referral-seeking mail ("Seeking Assistance for a Suitable Job Opportunity") is intentionally NOT matched — it's not a targeted application.
3. For each truly new candidate: pulls the thread, then acquires the resume — **first** the first PDF attachment, and if there is none, **falls back to a resume link in the email body** (Google Drive `file/d/<id>` or `open?id=`, Google Docs, Dropbox, or a direct `.pdf` URL). Links are downloaded via `curl` and verified to be real PDFs (`%PDF` magic bytes); the Drive large-file confirm-token interstitial is handled. Also extracts GitHub/LinkedIn/portfolio URLs from the body (resume-host links are excluded from portfolio detection).
4. Writes `last_discovery.json` next to the skill root with two arrays: `manifest` (candidates to ingest) and `skipped` (with reasons). Each manifest entry records `resumePath` (local PDF or null), `resumeSource` (`attachment` / `link:<host>` / `link_failed:<host>` / null), and `resumeLink` (the original URL when a link was found).

   **When a resume link can't be downloaded** (`resumeSource: "link_failed:*"`, `resumePath: null` but `resumeLink` set): the link is likely not shared as "anyone with the link", so `curl` got an HTML sign-in page. Fetch it with the **Google Drive MCP tool** instead — `get_file_metadata` then `download_file_content` (or `read_file_content`) by the file ID in the URL — and save the PDF into `resumes/` before scoring.

**No Notion pages are created in this stage.** That's intentional — we want to apply the rubric judgment before writing.

### Stage 2: Score + create page (model-driven)

For each entry in `last_discovery.json` → `manifest`:

1. **Read the resume PDF** with the Read tool (path is in `resumePath`). PDFs render to text inline — note the candidate's YOE, employer history, project metrics, education.
2. **WebFetch GitHub** (if `github` URL present) — look at pinned repos, contribution recency, agent/LLM repos with stars, and whether the work looks tutorial-grade or substantive.
3. **WebFetch portfolio** (if `profileUrl` present) — check whether it's custom or template, what projects are surfaced, any production GenAI work mentioned.
4. **Score 1-10** per `references/scoring_criteria.md`. Apply the calibration anchors strictly (Anchor A=8, Anchor B=6, Anchor C=5). If the candidate is currently at a service company on the cap list, **cap the score at 5 regardless of claimed metrics**.
5. **Compose the Profile Summary fields**: YOE, Companies & Type, Promotions, GitHub Activity, Notable, Red Flags. These are factual signal extraction — don't repeat the Score Reason text here.
6. **Pipe a JSON object to `scripts/create_candidate.mjs`** to create the page atomically:

```bash
cat <<'EOF' | node scripts/create_candidate.mjs
{
  "name": "...",
  "email": "...",
  "github": "https://github.com/...",
  "linkedin": "https://linkedin.com/in/...",
  "profileUrl": "...",
  "threadId": "...",
  "score": 7,
  "scoreReason": "2-4 sentence reasoning here...",
  "resumePath": "/abs/path/from/manifest.pdf",
  "resumeFilename": "...",
  "summary": {
    "yoe": "...",
    "companies": "...",
    "promotions": "...",
    "github": "...",
    "notable": "...",
    "redFlags": "..."
  },
  "bodyExcerpt": "(optional) email body text for the Application excerpt block"
}
EOF
```

The script uploads the PDF to Notion, computes Recommendation from Score (9-10→Strong Yes, 7-8→Yes, 6→Maybe, 4-5→No, 1-3→Strong No), and creates the page with Profile Summary as the first body block. It prints the new page URL on stdout.

### Output to the user

After ingestion, print a ranked summary table of new candidates with their scores so the user can see what was added.

## How to run end-to-end

```bash
# Stage 1: discover new applications, download resumes
node scripts/discover_new.mjs

# Inspect last_discovery.json to see what was found

# Stage 2 (per candidate): score + create the page (see "Stage 2" section above for the JSON payload)
cat <<EOF | node scripts/create_candidate.mjs
{ ...candidate JSON with score, reason, summary... }
EOF
```

The scripts read the Notion token from `~/.config/notion/api_key` (override with `NOTION_TOKEN`), use `gog` for Gmail access (must be authenticated; `gog gmail labels list` should succeed), and write resume PDFs to `resumes/` next to the skill root.

## Scoring algorithm

**Always read `references/scoring_criteria.md` before scoring** — it contains the calibration anchors (Anchor A=8, Anchor B=6, Anchor C=5) and the service-company cap rules. The scoring rubric is non-trivial and has evolved through user calibration, so deviating from it produces inconsistent results.

When scoring a candidate, base your judgment on:
- **Resume PDF content** — read with the Read tool; YOE, employers, project metrics
- **Email body** — cover letter quality, links, claimed substance
- **GitHub profile** (if URL present) — pinned repos, stars, recent activity, depth vs tutorial work
- **Portfolio site** (if URL present) — custom vs template, projects shown

If a candidate is missing the resume PDF (e.g., they linked to it externally), score from email body + GitHub + portfolio with a "no resume" red flag noted.

## Required fields when creating a Notion page

Use the schema in `references/notion_schema.md` for the exact property formats. Minimum required:

- `Name` (title)
- `Position` = "AI Engineer"
- `Status` = "Not started" (the user reviews and decides — do not pre-set Intro Call or Rejected from this skill)
- `Source` = "Inbound"
- `Email` (extracted from sender or resume)
- `Score` (1-10, number)
- `Recommendation` (Strong Yes / Yes / Maybe / No / Strong No — derived from score)
- `Score Reason` (rich_text, 2-4 sentences)
- `Resume` (file_upload type pointing to the uploaded PDF, OR external link if no PDF available)
- `Github`, `Linkedin`, `Profile URL` if present in body/resume

After scoring, **append** (not prepend) a `## Profile Summary` block to the page body using `PATCH /v1/blocks/<pageId>/children` with a `children` array. The Notion REST API does not support inserting at the top of an existing page — only appending to the end (or after a specific block via the `after` field).

The Profile Summary block must list these 6 rows: YOE / Companies & Type / Promotions / GitHub Activity / Notable / Red Flags. Don't duplicate Score Reason content in this block — keep it factual signal extraction (Score Reason explains the *why*, Profile Summary lists raw facts).

## Duplicate handling

The script does two layers of dedupe automatically:

1. **By sender email** — anything whose Gmail From address matches an `Email` property in Notion is skipped silently.
2. **By candidate name** — same-person-different-email re-applications (e.g. someone applied once from `name@gmail.com` and again from `name@school.edu`) are caught by normalized name match. If a name match is found, the candidate is skipped and a `SKIP [...] name match for "Name"` line is printed pointing at the existing page.

A third layer is your responsibility:

3. **By resume's contact email** — when you read the PDF for scoring, the resume itself may list a different email than the sender. If that email is already in Notion, flag the duplicate in the run summary and consider archiving the page the script just created. (Future improvement: pre-read the resume during ingestion and unify the dedupe.)

When a name-based skip is conservative (false positive — same name but different real person), the user can manually re-ingest after deleting/renaming the existing entry.

## Files in this skill

```
ingest-applications/
├── SKILL.md
├── scripts/
│   ├── discover_new.mjs      — Stage 1: find Gmail apps not in Notion, download PDFs, output manifest
│   ├── create_candidate.mjs  — Stage 2: read candidate JSON from stdin, upload resume, create page with Profile Summary
│   └── lib/
│       ├── notion.mjs        — Notion API helpers (iterCandidates, uploadResume, existingNames, recommendationFor)
│       └── gmail.mjs         — gog wrapper helpers (search, threads, attachments, link extraction)
├── references/
│   ├── scoring_criteria.md   — calibrated 1-10 rubric + anchors
│   └── notion_schema.md      — exact property names + value formats
├── evals/
│   └── evals.json
├── resumes/                  — (generated) downloaded PDFs; safe to clear once ingested into Notion
└── last_discovery.json       — (generated) manifest from the latest discover_new.mjs run
```
