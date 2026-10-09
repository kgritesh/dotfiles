// Gmail helpers via the `gog` CLI. Requires `gog` to be installed and authenticated:
//   gog gmail labels list   # should succeed without prompting

import { execFileSync } from "node:child_process";
import { readFileSync, existsSync, unlinkSync } from "node:fs";

const MAX_BUFFER = 100 * 1024 * 1024;

export function gog(args, opts = {}) {
  const out = execFileSync("gog", args, { maxBuffer: MAX_BUFFER, ...opts });
  return out == null ? "" : out.toString();
}

export function gogJson(args) {
  return JSON.parse(gog(args));
}

// Search threads. Returns the raw message list (each entry has id, threadId, from, subject, date).
export function searchMessages(query, { max = 50, full = false } = {}) {
  const args = ["gmail", "messages", "search", query, "--json", "--max", String(max)];
  if (full) args.push("--include-body", "--full");
  return gogJson(args).messages || [];
}

export function getThread(threadId) {
  return gogJson(["gmail", "threads", "get", threadId, "--json"]);
}

// Walk message payload parts looking for the first PDF attachment.
export function findPdfAttachment(thread) {
  for (const msg of thread.thread?.messages || []) {
    const walk = (part) => {
      if (!part) return null;
      const fn = part.filename || "";
      const aid = part.body?.attachmentId;
      if (fn.toLowerCase().endsWith(".pdf") && aid) return { msgId: msg.id, attId: aid, filename: fn };
      for (const sub of part.parts || []) {
        const found = walk(sub);
        if (found) return found;
      }
      return null;
    };
    const found = walk(msg.payload);
    if (found) return found;
  }
  return null;
}

export function downloadAttachment(msgId, attId, outPath) {
  execFileSync("gog", ["gmail", "attachment", msgId, attId, "--out", outPath], {
    maxBuffer: MAX_BUFFER,
    stdio: ["ignore", "ignore", "inherit"],
  });
}

// Detect a resume DOWNLOAD link in the email body (used when there is no PDF attachment).
// Many applicants paste a Google Drive / Docs / Dropbox link or a direct .pdf URL instead of
// attaching the file. Returns { url, downloadUrl, host, fileId? } for the first such link, or null.
const RESUME_HINT = /\b(resume|cv|c\.v\.|curriculum\s*vitae)\b/i;
export function extractResumeLink(text) {
  const clean = (u) => u.replace(/[.,;:)\]>"']+$/, "");
  const urls = ((text || "").match(URL_RE) || []).map(clean);

  const classify = (url) => {
    const lower = url.toLowerCase();
    let m = url.match(/drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)/)
         || url.match(/drive\.google\.com\/open\?id=([a-zA-Z0-9_-]+)/)
         || url.match(/drive\.google\.com\/uc\?[^\s]*\bid=([a-zA-Z0-9_-]+)/);
    if (m) return { url, host: "drive", fileId: m[1], downloadUrl: `https://drive.google.com/uc?export=download&id=${m[1]}` };
    m = url.match(/docs\.google\.com\/document\/d\/([a-zA-Z0-9_-]+)/);
    if (m) return { url, host: "gdocs", fileId: m[1], downloadUrl: `https://docs.google.com/document/d/${m[1]}/export?format=pdf` };
    if (lower.includes("dropbox.com/")) {
      const forced = /[?&]dl=/.test(url) ? url.replace(/([?&])dl=0/, "$1dl=1") : url + (url.includes("?") ? "&dl=1" : "?dl=1");
      return { url, host: "dropbox", downloadUrl: forced };
    }
    if (/\.pdf($|\?)/i.test(lower)) return { url, host: "direct", downloadUrl: url };
    return null;
  };

  // Prefer a link that sits on a line mentioning "resume"/"cv"; otherwise the first downloadable link.
  let firstDownloadable = null;
  for (const line of (text || "").split(/\r?\n/)) {
    for (const raw of line.match(URL_RE) || []) {
      const link = classify(clean(raw));
      if (!link) continue;
      if (RESUME_HINT.test(line)) return link;
      if (!firstDownloadable) firstDownloadable = link;
    }
  }
  if (firstDownloadable) return firstDownloadable;
  for (const url of urls) { const link = classify(url); if (link) return link; }
  return null;
}

// Download a resume from a public URL via curl, verifying the result is actually a PDF.
// Handles Google Drive's large-file "confirm token" interstitial. Returns true on success;
// on failure removes the partial/garbage file and returns false (caller falls back to the
// Drive MCP tool, which works for links that are not shared "anyone with the link").
export function downloadFromUrl(downloadUrl, outPath) {
  const fetch = (url) =>
    execFileSync("curl", ["-sL", "--max-time", "90", url, "-o", outPath], {
      maxBuffer: MAX_BUFFER,
      stdio: ["ignore", "ignore", "inherit"],
    });

  const isPdf = () => existsSync(outPath) && readFileSync(outPath).subarray(0, 5).toString("latin1").startsWith("%PDF");

  fetch(downloadUrl);
  if (isPdf()) return true;

  // Drive sometimes returns an HTML interstitial with a confirm token for larger files.
  if (/drive\.google|docs\.google/.test(downloadUrl) && existsSync(outPath)) {
    const tok = readFileSync(outPath).toString("utf8").match(/confirm=([0-9A-Za-z_-]+)/);
    if (tok) {
      fetch(`${downloadUrl}${downloadUrl.includes("?") ? "&" : "?"}confirm=${tok[1]}`);
      if (isPdf()) return true;
    }
  }

  if (existsSync(outPath)) { try { unlinkSync(outPath); } catch {} }
  return false;
}

// Parse "Name <email@example.com>" from the From header.
export function parseFrom(fromRaw) {
  const m = fromRaw.match(/^"?([^"<]+?)"?\s*<([^>]+)>/) || fromRaw.match(/([\w.+-]+@[\w.-]+\.[A-Za-z]{2,})/);
  if (!m) return { name: null, email: null };
  return m.length === 3 ? { name: m[1].trim(), email: m[2].toLowerCase() } : { name: null, email: m[1].toLowerCase() };
}

// Extract first URL matching predicate from a body string.
const URL_RE = /https?:\/\/[^\s<>"')\]]+/g;

export function extractLinks(text) {
  const found = {};
  for (const url of (text || "").match(URL_RE) || []) {
    const lower = url.toLowerCase();
    if (!found.github && lower.includes("github.com/")) found.github = url.replace(/[.,;)]+$/, "");
    if (!found.linkedin && lower.includes("linkedin.com/in/")) found.linkedin = url.replace(/[.,;)]+$/, "");
    // anything else that's not a known social or resume-host link can be the portfolio
    const isResumeHost = lower.includes("drive.google") || lower.includes("docs.google") || lower.includes("dropbox.com") || /\.pdf($|\?)/.test(lower);
    if (!found.portfolio && !lower.includes("github.com") && !lower.includes("linkedin.com") && !lower.includes("mail.google") && !lower.includes("gmail") && !isResumeHost) {
      found.portfolio = url.replace(/[.,;)]+$/, "");
    }
  }
  return found;
}
