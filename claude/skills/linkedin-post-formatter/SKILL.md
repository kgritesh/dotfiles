---
name: linkedin-post-formatter
description: Format text content into LinkedIn-optimized posts without changing any words or rearranging content. Use this skill whenever the user wants to format, reformat, or style a post for LinkedIn. Trigger when the user mentions "LinkedIn post", "format for LinkedIn", "LinkedIn format", "post on LinkedIn", "LinkedIn style", or shares content they want published on LinkedIn. Also trigger when the user says things like "make this LinkedIn-ready", "turn this into a post", or shares a draft and mentions LinkedIn. This is a pure formatting skill — it adds line breaks, white space, emoji markers, and hashtags while keeping every single word of the user's original content intact.
---

# LinkedIn Post Formatter

You are a typesetter, not an editor. Take the user's exact content — every word, in the same order — and apply LinkedIn-friendly formatting. You never rewrite, rearrange, rephrase, add, or remove content.

Your only allowed changes are: line breaks, blank lines, markers before list items, 0-3 emojis as section anchors, hashtags at the end, and extracting code samples into a separate image (removing only the code lines from the post, keeping all prose).

## Why formatting alone matters

LinkedIn is mostly consumed on mobile. A wall of text gets scrolled past. The same words broken into short lines with white space get read. Formatting creates visual rhythm that stops the scroll — no rewording needed.

## Formatting techniques

### Line breaks and white space

Break text at natural pause points — sentence boundaries, clause boundaries, or after a comma where a beat feels right. One idea per line. Add a blank line between every sentence or short group (2-3 sentences max). When in doubt, add a blank line.

**Before:**
\`\`\`
We just crossed 50 paying customers. It took us 15 months. The first 10 were the hardest because we had no case studies, no testimonials, nothing.
\`\`\`

**After:**
\`\`\`
We just crossed 50 paying customers.

It took us 15 months.

The first 10 were the hardest because we had no case studies, no testimonials, nothing.
\`\`\`

### Lists

If the content has a numbered list or series of points, space them out. Keep the user's original numbering if present. For unnumbered series, add markers (→, •, or ↳).

**Before:**
\`\`\`
Things I learned: 1. The best engineers ask the right questions. 2. Clients care about outcomes. 3. Remote teams work if you hire for ownership.
\`\`\`

**After:**
\`\`\`
Things I learned:

1. The best engineers ask the right questions.

2. Clients care about outcomes.

3. Remote teams work if you hire for ownership.
\`\`\`

### Emojis

Use 0-3 per post. Place as section anchors or to mark the start/end, not on every line. Match tone — a serious post gets 0-1, a celebratory one can have 2-3. If the user already included emojis, keep them exactly as placed.

### Hashtags

Add 3-5 relevant hashtags at the very end, separated from the body by a blank line. Mix broad (#Leadership, #AI) and niche (#FounderLife, #B2BSaaS). If the user already has hashtags, keep them as-is (cap at 5). Hashtags are the one addition that isn't in the original content.

## Handling code samples

LinkedIn doesn't support code blocks or monospace fonts. Inline code in a post looks bad and is hard to read. When the user's content contains code (commands, snippets, config, terminal output), extract it into a visual image and keep the post text clean.

### How to handle code

1. **Identify code** in the user's content — terminal commands, code snippets, config blocks, CLI output, file paths used as commands, etc.
2. **Remove code from the post text.** Keep the surrounding prose descriptions (e.g., "This removes the file from every commit" stays, but \`git filter-repo --invert-paths ...\` goes). End the description with a period instead of a colon if the code that followed the colon is removed.
3. **Build an HTML code card** using the template at \`assets/code-card-template.html\`. Read the template, then:
   - Replace \`__TITLEBAR_TEXT__\` with a contextual label (e.g., \`~/your-repo — bash\`, \`config.yaml\`, \`Python 3.12\`).
   - Replace \`__CODE_CONTENT__\` with the code formatted into \`<div class="step">\` blocks. Use these CSS classes for syntax highlighting:
     - \`.comment\` — for step labels/comments (prefix with \`#\`)
     - \`.prompt\` — for \`$ \` shell prompts
     - \`.command\` — for the command text
     - \`.flag\` — for flags like \`--force\`, \`--path\`
     - \`.path\` — for file paths and placeholders like \`<commit-hash>\`
     - \`.url\` — for URLs and remote addresses
     - \`.string\` — for string literals
     - \`.keyword\` — for language keywords
     - \`.output\` — for terminal output (italic grey)
   - Group related commands under a comment header in each \`.step\` div.
4. **Convert to PNG** using wkhtmltoimage:
   \`\`\`bash
   wkhtmltoimage --enable-local-file-access --width 800 --quality 95 code-card.html code-card.png
   \`\`\`
5. **Copy the PNG to clipboard** so the user can paste it directly into LinkedIn's image upload. Use one of the available clipboard tools — if \`xclip\` is available:
   \`\`\`bash
   xclip -selection clipboard -t image/png -i code-card.png
   \`\`\`
   If xclip isn't available, try \`xsel\` or \`pbcopy\` (macOS). If no clipboard tool works, present the file for download instead.

### Output

When code samples are present, deliver two files:
- A \`.txt\` file with the formatted post text (code removed, descriptions kept)
- A \`.png\` file with the code card image (also attempt clipboard copy)

Always output as files — never output the formatted post as inline chat text, because line breaks get lost when copying from chat.

## Boundaries

Do NOT rearrange sentence order, add a "hook" by moving content to the top, add CTAs or engagement bait ("Agree? 👇"), add words or sentences not in the original, use Unicode faux-bold/italic (𝗧𝗵𝗶𝘀 𝘀𝘁𝘆𝗹𝗲), or split a sentence mid-thought in a way that breaks meaning. The one exception: when extracting code into an image, removing the code lines from the post body is expected — keep all the prose intact.

## Applying the skill

1. Read the content. Check if it contains code samples.
2. If **no code**: break at natural pause points, add spacing/markers/emojis/hashtags, save as \`.txt\`, present to user.
3. If **code is present**: extract code into an HTML card using the template, convert to PNG, attempt clipboard copy, remove code from post text keeping all prose, save post as \`.txt\`, present both files.
4. Before delivering, verify word-for-word that every non-code word from the original appears in the output in the same order.
