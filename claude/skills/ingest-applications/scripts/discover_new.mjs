#!/usr/bin/env node
// Stage 1 of ingestion (deterministic): discover Gmail application threads not in Notion,
// download attached PDFs, extract URLs from email body, and emit a manifest.
//
// DOES NOT create Notion pages. The model that invoked this skill scores each candidate
// and then calls scripts/create_candidate.mjs per entry — that's where the page is
// created atomically with Score + Profile Summary baked in.
//
// Output: writes last_discovery.json next to this script's parent dir.

import { writeFileSync, existsSync, mkdirSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

import { iterCandidates, DATA_SOURCE_ID, existingNames } from "./lib/notion.mjs";
import { searchMessages, getThread, findPdfAttachment, downloadAttachment, parseFrom, extractLinks, extractResumeLink, downloadFromUrl } from "./lib/gmail.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const RESUMES_DIR = process.env.RESUMES_DIR || join(__dirname, "..", "resumes");
mkdirSync(RESUMES_DIR, { recursive: true });

const SEARCH_WINDOW_DAYS = Number(process.env.SEARCH_WINDOW_DAYS || 14);

// Subject signals applicants actually use. Kept broad on purpose: dedupe (by email + name)
// and the NOISE_SENDERS filter below remove any false positives this pulls in.
const SEARCH_QUERY = [
  `(subject:"AI Engineer" OR subject:application OR subject:apply OR subject:vertexcover OR subject:vertex OR subject:engineer OR subject:resume)`,
  `in:inbox`,
  `newer_than:${SEARCH_WINDOW_DAYS}d`,
  `-from:ritesh@vertexcover.io`,
  `-from:noreply`,
  `-from:no-reply`,
  `-from:notifications`,
].join(" ");

// Gmail can return well over 100 matches in the window; the old max:100 silently truncated
// the oldest in-window applications (which are exactly the un-ingested ones). Page deep.
const SEARCH_MAX = Number(process.env.SEARCH_MAX || 500);

const NOISE_SENDERS = /(noreply|no-reply|notification|donotreply|@indeedemail|@svsrecruiting|@instahyre|@cutshort\.io|@linkedin\.com|mail\.notion\.so|@slack\.com|@google\.com|payments-noreply|sesamelabs\.network|@glgroup\.com|@icici\.bank\.in|zoho-books|@sender\.|workspace\d*@gmail\.com|@aiboomi\.org|tinyemails|@mailer|@news\.|@email\.|@marketing|@nxtwaveprojects\.com|babysaas\.co|@reconmatches\.com|naman@refrens\.com)/i;

// Automated/calendar/SaaS subjects that the broadened subject filter can catch — never applications.
const NOISE_SUBJECT = /^(invitation:|accepted:|declined:|updated invitation|canceled event|re: invitation)|google meet|tax invoice|sales invoice|payment success|transaction (confirmation|alert)|bank statement|purchase order|your invoice|consultation/i;

const slug = (s) => (s || "").toLowerCase().replace(/[^a-z0-9]+/g, "_").replace(/^_|_$/g, "").slice(0, 60);
const nameKey = (s) => (s || "").toLowerCase().replace(/[^a-z0-9]+/g, "").trim();

async function main() {
  console.log(`[discover] Loading existing emails + names from Notion (data source ${DATA_SOURCE_ID})...`);
  const existing = new Set();
  for await (const p of iterCandidates(null)) {
    const e = p.properties.Email?.email;
    if (e) existing.add(e.toLowerCase());
  }
  const nameIndex = await existingNames();
  console.log(`[discover] ${existing.size} emails + ${nameIndex.size} names already in Notion\n`);

  console.log(`[discover] Searching Gmail (window=${SEARCH_WINDOW_DAYS}d)...`);
  const matches = searchMessages(SEARCH_QUERY, { max: SEARCH_MAX });
  console.log(`[discover] ${matches.length} Gmail matches before dedupe\n`);

  const seenThreads = new Set();
  const toProcess = [];
  const skipped = [];
  for (const m of matches) {
    if (!m.threadId || seenThreads.has(m.threadId)) continue;
    seenThreads.add(m.threadId);
    const { name: nameFromHeader, email } = parseFrom(m.from || "");
    if (!email) continue;
    if (NOISE_SENDERS.test(email)) { skipped.push({ reason: "noise_sender", email }); continue; }
    if (NOISE_SUBJECT.test(m.subject || "")) { skipped.push({ reason: "noise_subject", email, subject: m.subject }); continue; }
    if (existing.has(email)) { skipped.push({ reason: "email_in_notion", email }); continue; }
    const nk = nameKey(nameFromHeader);
    if (nk && nameIndex.has(nk)) {
      const dup = nameIndex.get(nk);
      skipped.push({ reason: "name_match", email, matched: { name: nameFromHeader, existingPageId: dup.pageId, existingEmail: dup.email } });
      console.log(`SKIP [${email}] name match "${nameFromHeader}" → existing page ${dup.pageId.slice(0,8)} (${dup.email || "no email"})`);
      continue;
    }
    toProcess.push({ ...m, senderEmail: email, senderName: nameFromHeader || email });
  }
  console.log(`[discover] ${toProcess.length} truly new candidates; ${skipped.length} skipped\n`);

  const manifest = [];
  for (const cand of toProcess) {
    const tag = `[${cand.senderEmail}]`;
    try {
      const thread = getThread(cand.threadId);

      // Extract plain-text body first — needed both for link extraction AND for the
      // resume-link fallback when the applicant pasted a link instead of attaching a PDF.
      const fullMsg = thread.thread?.messages?.find((m) => m.id === cand.messageId) || thread.thread?.messages?.[0];
      const acc = [];
      const walkParts = (part) => {
        if (!part) return;
        if (part.mimeType === "text/plain" && part.body?.data) {
          acc.push(Buffer.from(part.body.data, "base64").toString("utf8"));
        }
        for (const sub of part.parts || []) walkParts(sub);
      };
      walkParts(fullMsg?.payload);
      const bodyText = acc.join("\n");
      const links = extractLinks(bodyText);

      const outPath = join(RESUMES_DIR, `new__${slug(cand.senderName)}__${cand.threadId}.pdf`);
      let resumePath = null;
      let resumeFilename = null;
      let resumeSource = null; // "attachment" | "link:<host>" | "link_failed:<host>" | null
      let resumeLink = null;

      // 1) Prefer a real PDF attachment.
      const att = findPdfAttachment(thread);
      if (att) {
        if (!existsSync(outPath)) downloadAttachment(att.msgId, att.attId, outPath);
        resumePath = outPath;
        resumeFilename = att.filename;
        resumeSource = "attachment";
      } else {
        // 2) Fall back to a resume link in the body (Google Drive / Docs / Dropbox / direct PDF).
        const link = extractResumeLink(bodyText);
        if (link) {
          resumeLink = link.url;
          try {
            const ok = existsSync(outPath) || downloadFromUrl(link.downloadUrl, outPath);
            if (ok && existsSync(outPath)) {
              resumePath = outPath;
              resumeFilename = `resume_${slug(cand.senderName) || "candidate"}.pdf`;
              resumeSource = `link:${link.host}`;
            } else {
              resumeSource = `link_failed:${link.host}`;
            }
          } catch {
            resumeSource = `link_failed:${link.host}`;
          }
        }
      }

      manifest.push({
        name: cand.senderName,
        email: cand.senderEmail,
        threadId: cand.threadId,
        messageId: cand.messageId,
        subject: cand.subject || "",
        resumePath,
        resumeFilename,
        resumeSource,
        resumeLink,
        github: links.github || null,
        linkedin: links.linkedin || null,
        portfolio: links.portfolio || null,
        body: bodyText.trim(),
      });
      const resumeState = resumePath ? resumeSource : (resumeLink ? `link-failed (${resumeLink})` : "none");
      console.log(`OK   ${tag.padEnd(40)} ${cand.senderName.padEnd(28)} resume=${resumeState}`);
    } catch (e) {
      manifest.push({ name: cand.senderName, email: cand.senderEmail, error: e.message });
      console.log(`ERR  ${tag.padEnd(40)} ${cand.senderName.padEnd(28)} ${e.message.slice(0, 120)}`);
    }
  }

  const outPath = join(__dirname, "..", "last_discovery.json");
  writeFileSync(outPath, JSON.stringify({ skipped, manifest }, null, 2));
  console.log(`\n[discover] Wrote ${outPath} (${manifest.length} candidates, ${skipped.length} skips)`);
  console.log(`\n[discover] NEXT STEP for the invoking model:`);
  console.log(`[discover]   For each entry in manifest:`);
  console.log(`[discover]     1. Read the resume PDF (Read tool, resumePath).`);
  console.log(`[discover]        - If resumePath is null but resumeLink is set (resumeSource=link_failed:*),`);
  console.log(`[discover]          the link wasn't publicly downloadable — fetch it via the Google Drive MCP`);
  console.log(`[discover]          tool (get_file_metadata / download_file_content by file ID) and save to resumes/.`);
  console.log(`[discover]     2. WebFetch the github / portfolio URLs for signal depth`);
  console.log(`[discover]     3. Score per references/scoring_criteria.md`);
  console.log(`[discover]     4. Pipe a JSON object to scripts/create_candidate.mjs via stdin to create the Notion page`);
}

main().catch((e) => { console.error(e); process.exit(1); });
