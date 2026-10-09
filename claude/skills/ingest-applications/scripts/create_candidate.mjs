#!/usr/bin/env node
// Stage 2 of ingestion (model-driven): create ONE Notion candidate page atomically
// with all fields including Profile Summary as the FIRST body block.
//
// Input: JSON object on stdin describing the candidate. Schema:
// {
//   "name": "Required full name",
//   "email": "candidate@example.com",
//   "github": "https://github.com/... (optional)",
//   "linkedin": "https://... (optional)",
//   "profileUrl": "https://... (optional)",
//   "threadId": "Gmail thread id (optional, links source in body)",
//   "score": 7,
//   "scoreReason": "2-4 sentence reasoning",
//   "resumePath": "/absolute/path/to/resume.pdf (optional)",
//   "resumeFilename": "DisplayName.pdf (optional, defaults to basename)",
//   "externalResumeUrl": "https://... (optional, used if resumePath absent)",
//   "summary": {
//     "yoe": "...",
//     "companies": "...",
//     "promotions": "...",
//     "github": "...",
//     "notable": "...",
//     "redFlags": "..."
//   },
//   "bodyExcerpt": "Optional: raw email body text to include as a quote block"
// }
//
// Output: prints the new page URL on stdout.

import { readFileSync } from "node:fs";
import { basename } from "node:path";
import { notion, DATA_SOURCE_ID, uploadResume, recommendationFor } from "./lib/notion.mjs";

const stdin = readFileSync(0, "utf8");
if (!stdin.trim()) { console.error("Empty stdin. Pipe a JSON object describing the candidate."); process.exit(2); }
let c;
try { c = JSON.parse(stdin); } catch (e) { console.error(`Bad JSON on stdin: ${e.message}`); process.exit(2); }

for (const f of ["name", "email", "score", "scoreReason", "summary"]) {
  if (c[f] == null || c[f] === "") { console.error(`Missing required field: ${f}`); process.exit(2); }
}
if (typeof c.score !== "number" || c.score < 1 || c.score > 10) {
  console.error(`score must be a number 1-10, got: ${c.score}`); process.exit(2);
}
const rec = recommendationFor(c.score);

// Upload resume (or use external link)
let resumeUploadId = null;
const resumeFilename = c.resumeFilename || (c.resumePath ? basename(c.resumePath) : "Resume.pdf");
if (c.resumePath) {
  resumeUploadId = await uploadResume(c.resumePath, resumeFilename);
}

const properties = {
  Name: { title: [{ text: { content: c.name } }] },
  Position: { select: { name: "AI Engineer" } },
  Status: { status: { name: "Not started" } },
  Source: { select: { name: "Inbound" } },
  Email: { email: c.email },
  Score: { number: c.score },
  Recommendation: { select: { name: rec } },
  "Score Reason": { rich_text: [{ text: { content: c.scoreReason } }] },
};
if (c.github) properties.Github = { url: c.github };
if (c.linkedin) properties.Linkedin = { url: c.linkedin };
if (c.profileUrl) properties["Profile URL"] = { url: c.profileUrl };
if (resumeUploadId) {
  properties.Resume = { files: [{ name: resumeFilename, type: "file_upload", file_upload: { id: resumeUploadId } }] };
} else if (c.externalResumeUrl) {
  properties.Resume = { files: [{ name: resumeFilename || "Resume (external)", type: "external", external: { url: c.externalResumeUrl } }] };
}

// Children: Profile Summary block FIRST, then divider, then email/source thread, then optional excerpt.
const summary = c.summary;
const bulletRow = (label, value) => ({
  object: "block", type: "bulleted_list_item",
  bulleted_list_item: { rich_text: [
    { text: { content: label + ": " }, annotations: { bold: true } },
    { text: { content: String(value || "(not provided)") } },
  ] },
});

const children = [
  { object: "block", type: "heading_2", heading_2: { rich_text: [{ text: { content: "Profile Summary" } }] } },
  bulletRow("Years of Experience", summary.yoe),
  bulletRow("Companies & Type", summary.companies),
  bulletRow("Promotions / Trajectory", summary.promotions),
  bulletRow("GitHub Activity", summary.github),
  bulletRow("Notable", summary.notable),
  bulletRow("Red Flags", summary.redFlags),
  { object: "block", type: "divider", divider: {} },
  { object: "block", type: "paragraph", paragraph: { rich_text: [
    { text: { content: "Email: " }, annotations: { bold: true } },
    { text: { content: c.email } },
  ] } },
];
if (c.threadId) {
  children.push({
    object: "block", type: "paragraph",
    paragraph: { rich_text: [
      { text: { content: "Source thread: " }, annotations: { bold: true } },
      { text: { content: `https://mail.google.com/mail/u/0/#inbox/${c.threadId}`, link: { url: `https://mail.google.com/mail/u/0/#inbox/${c.threadId}` } } },
    ] },
  });
}
if (c.bodyExcerpt) {
  children.push({ object: "block", type: "divider", divider: {} });
  children.push({ object: "block", type: "heading_3", heading_3: { rich_text: [{ text: { content: "Application excerpt" } }] } });
  children.push({ object: "block", type: "quote", quote: { rich_text: [{ text: { content: c.bodyExcerpt.slice(0, 1800) } }] } });
}

const page = await notion(`/pages`, {
  method: "POST",
  body: JSON.stringify({ parent: { data_source_id: DATA_SOURCE_ID }, properties, children }),
});

console.log(page.url);
console.error(`Created page ${page.id} for ${c.name} (score=${c.score}, rec=${rec})`);
