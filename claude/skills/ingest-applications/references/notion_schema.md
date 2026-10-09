# Notion Hiring Pipeline Schema

Data source ID: `09011c67-f4a2-472b-b510-76abee96de97`
Database URL: <https://www.notion.so/535a2880787c47ac96691e57870e76ad>

API version: `Notion-Version: 2025-09-03`
Auth: bearer token from `~/.config/notion/api_key` (override with `NOTION_TOKEN` env var)

## Properties

| Property | Type | Format when writing |
|----------|------|---------------------|
| `Name` | title | `{ title: [{ text: { content: "..." } }] }` |
| `Position` | select | `{ select: { name: "AI Engineer" } }` — options: Internship, Generalist Software Engineer, AI/ML Lead, AI Engineer |
| `Status` | status | `{ status: { name: "Not started" } }` — Not started / Intro Call / Assignment / Tech Round / Team Round / Pair Programming Round / Offer / Hold / Declined / Rejected |
| `Source` | select | `{ select: { name: "Inbound" } }` — Inbound, Outbound, plus referral/job-board options |
| `Email` | email | `{ email: "user@example.com" }` |
| `Github` | url | `{ url: "https://github.com/..." }` |
| `Linkedin` | url | `{ url: "https://linkedin.com/in/..." }` |
| `Profile URL` | url | `{ url: "https://..." }` (portfolio site) |
| `Score` | number | `{ number: 7 }` (1-10) |
| `Recommendation` | select | `{ select: { name: "Yes" } }` — Strong Yes / Yes / Maybe / No / Strong No |
| `Score Reason` | rich_text | `{ rich_text: [{ text: { content: "..." } }] }` — 2-4 sentences |
| `Resume` | files | See "Resume upload" below |
| `Reject Mail Sent At` | date | `{ date: { start: "2026-05-26T15:00:00.000Z" } }` — only set after rejection email actually sends |
| `Assign` | people | Not set by this skill |
| `Assignment` | rich_text | Not set by this skill |
| `Due Date` | date | Not set by this skill |

## Resume upload (the only tricky one)

Notion's file upload is a 3-step flow:

```javascript
// 1. Create upload reservation
const created = await fetch("https://api.notion.com/v1/file_uploads", {
  method: "POST",
  headers: { Authorization: `Bearer ${TOKEN}`, "Notion-Version": "2025-09-03", "Content-Type": "application/json" },
  body: JSON.stringify({ filename: "Resume.pdf", content_type: "application/pdf" }),
}).then(r => r.json());

const uploadId = created.id;

// 2. Send the file bytes
const form = new FormData();
form.append("file", new Blob([pdfBuffer], { type: "application/pdf" }), "Resume.pdf");
await fetch(`https://api.notion.com/v1/file_uploads/${uploadId}/send`, {
  method: "POST",
  headers: { Authorization: `Bearer ${TOKEN}`, "Notion-Version": "2025-09-03" }, // NO Content-Type — FormData sets it
  body: form,
});

// 3. Reference it in the page property
properties.Resume = {
  files: [{ name: "Resume.pdf", type: "file_upload", file_upload: { id: uploadId } }],
};
```

**External link alternative** — when the candidate didn't attach a PDF (linked a Google Doc or shortener):
```javascript
properties.Resume = {
  files: [{ name: "Candidate Portfolio (external)", type: "external", external: { url: "https://..." } }],
};
```

## Creating a page

```javascript
await fetch("https://api.notion.com/v1/pages", {
  method: "POST",
  headers: { Authorization: `Bearer ${TOKEN}`, "Notion-Version": "2025-09-03", "Content-Type": "application/json" },
  body: JSON.stringify({
    parent: { data_source_id: "09011c67-f4a2-472b-b510-76abee96de97" },
    properties: { /* see table above */ },
    children: [ /* Profile Summary block + email/source-thread paragraphs */ ],
  }),
});
```

## Querying for existing candidates (to dedupe by email)

```javascript
const r = await fetch(
  `https://api.notion.com/v1/data_sources/09011c67-f4a2-472b-b510-76abee96de97/query`,
  {
    method: "POST",
    headers: { Authorization: `Bearer ${TOKEN}`, "Notion-Version": "2025-09-03", "Content-Type": "application/json" },
    body: JSON.stringify({ page_size: 100, start_cursor: cursor }),
  }
).then(r => r.json());
```

Iterate `r.results`, paginate with `r.next_cursor` while `r.has_more`.

## Common pitfalls

1. **Re-using `Content-Type: application/json` when sending FormData** — must omit it; the Blob's boundary header will be wrong.
2. **Setting `Status: "Intro Call"` from the ingestion skill** — don't. The user reviews and decides. Always leave new pages as `Not started`.
3. **Score=null when Notion's filter expects a number** — when filtering for `Score is_empty`, the Score property has `number: null`. When writing, just use `{ number: 7 }`.
4. **Adding the wrong Position option name** — only the four options listed above. Capitalization matters.
5. **The Notion MCP `file://` URL** is INTERNAL — not directly downloadable. To read a resume via the API, query the page (`GET /v1/pages/<id>`) and use `properties.Resume.files[0].file.url` which IS a signed S3 URL valid for ~1 hour.
