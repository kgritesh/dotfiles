// Notion API helpers — uses bearer token from $NOTION_TOKEN or ~/.config/notion/api_key.

import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

export const NOTION_VERSION = "2025-09-03";
export const DATA_SOURCE_ID = process.env.NOTION_DATA_SOURCE_ID || "09011c67-f4a2-472b-b510-76abee96de97";

function loadToken() {
  if (process.env.NOTION_TOKEN) return process.env.NOTION_TOKEN.trim();
  return readFileSync(join(homedir(), ".config", "notion", "api_key"), "utf8").trim();
}

const TOKEN = loadToken();

export async function notion(path, init = {}) {
  const headers = {
    Authorization: `Bearer ${TOKEN}`,
    "Notion-Version": NOTION_VERSION,
    ...(init.headers || {}),
  };
  // Don't auto-set Content-Type when the caller is sending FormData
  if (!(init.body instanceof FormData) && init.body && !headers["Content-Type"]) {
    headers["Content-Type"] = "application/json";
  }
  const res = await fetch(`https://api.notion.com/v1${path}`, { ...init, headers });
  if (!res.ok) throw new Error(`Notion ${init.method || "GET"} ${path} → ${res.status} ${await res.text()}`);
  return res.json();
}

export const plainText = (prop) => {
  if (!prop) return "";
  if (prop.type === "title") return prop.title.map((t) => t.plain_text).join("").trim();
  if (prop.type === "rich_text") return prop.rich_text.map((t) => t.plain_text).join("").trim();
  return "";
};

export async function* iterCandidates(filter) {
  let cursor;
  do {
    const body = { page_size: 100 };
    if (filter) body.filter = filter;
    if (cursor) body.start_cursor = cursor;
    const r = await notion(`/data_sources/${DATA_SOURCE_ID}/query`, {
      method: "POST",
      body: JSON.stringify(body),
    });
    for (const p of r.results) yield p;
    cursor = r.has_more ? r.next_cursor : undefined;
  } while (cursor);
}

// Build a {normalized_name → email} map so we can detect same-person-different-email
// reapplications (e.g. someone applies once from gmail and again from school email).
export async function existingNames() {
  const map = new Map();
  for await (const p of iterCandidates(null)) {
    const name = plainText(p.properties.Name);
    if (!name) continue;
    const key = name.toLowerCase().replace(/[^a-z0-9]+/g, "").trim();
    if (!key) continue;
    const email = p.properties.Email?.email || null;
    if (!map.has(key)) map.set(key, { name, email, pageId: p.id });
  }
  return map;
}

export async function uploadResume(filePath, filename) {
  const created = await notion(`/file_uploads`, {
    method: "POST",
    body: JSON.stringify({ filename, content_type: "application/pdf" }),
  });
  const uploadId = created.id;
  const buf = readFileSync(filePath);
  const form = new FormData();
  form.append("file", new Blob([buf], { type: "application/pdf" }), filename);
  await notion(`/file_uploads/${uploadId}/send`, { method: "POST", body: form });
  return uploadId;
}

export function recommendationFor(score) {
  if (score >= 9) return "Strong Yes";
  if (score >= 7) return "Yes";
  if (score === 6) return "Maybe";
  if (score >= 4) return "No";
  return "Strong No";
}
