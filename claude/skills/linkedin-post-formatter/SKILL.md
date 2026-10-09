---
name: linkedin-post-formatter
description: >-
  Format text content into LinkedIn-optimized posts and optionally help refine the writing. Use this skill
  whenever the user wants to format, reformat, or style a post for LinkedIn. Trigger when the user mentions
  "LinkedIn post", "format for LinkedIn", "LinkedIn format", "post on LinkedIn", "LinkedIn style", or
  shares content they want published on LinkedIn. Also trigger for requests such as "make this
  LinkedIn-ready" or "turn this into a post" when LinkedIn is mentioned. Supports pure formatting, an
  optional de-AI pass, and an optional self-review pass. Wording changes are always proposed for approval,
  never silently applied.
---

# LinkedIn Post Formatter

You have one core job and two optional ones.

Core (always): typeset the user's content for LinkedIn — line breaks, white space, hashtags, code-card extraction. No word changes.

Optional pass 1 (offer when the post reads as AI-written): propose specific edits to make it sound human. User must approve before any words change.

Optional pass 2 (offer at the end): review the post for repetitions, rough spots, and tics. Propose fixes. User must approve.

The user is always in control of the words. You only change wording when the user explicitly approves a proposed edit.

## Why formatting alone matters

LinkedIn is mostly consumed on mobile. A wall of text gets scrolled past. The same words broken into short lines with white space get read. Formatting creates visual rhythm that stops the scroll — no rewording needed.

## Step 1: Detect post type before formatting

Spacing density should match the post's register. Pick one of three types based on the content:

- **Punchy / listicle / announcement** — short sentences, bullet points, achievements, "X things I learned" structure, celebratory tone. Use maximum white space: one idea per line, blank line between every sentence or short group.
- **Reflective / narrative / essay** — longer sentences, building an argument, telling a story, thoughtful tone. Use paragraph grouping: keep sentences that belong to the same beat together. Break between argument shifts, not between every sentence. Aim for 2-5 sentences per paragraph.
- **Mixed** — a reflective piece with a list inside, or a punchy opener leading into a longer thought. Apply the right density to each section.

When in doubt between punchy and reflective, look at sentence length: if average sentences are short (under 15 words), lean punchy. If sentences are longer and build on each other, lean reflective.

The one-idea-per-line rule from the old version of this skill is wrong for reflective posts. It produces a choppy, breathless rhythm that undermines thoughtful writing. Use it only for punchy posts.

### Example: reflective post spacing

**Wrong (over-spaced):**
```
The longer we talked, the more I realized he doesn't actually miss coding.

He misses understanding his own work.

He builds something with an agent, it works, he ships it.

And at no point does he have the mental model of the system he used to have.
```

**Right (paragraph grouping):**
```
The longer we talked, the more I realized he doesn't actually miss coding. He misses understanding his own work. He builds something with an agent, it works, he ships it, and at no point does he have the mental model of the system he used to have.
```

### Example: punchy post spacing

**Right:**
```
We just crossed 50 paying customers.

It took us 15 months.

The first 10 were the hardest because we had no case studies, no testimonials, nothing.
```

## Step 2: Apply formatting

### Line breaks and white space

Break at natural pause points — sentence boundaries, clause boundaries, or after a comma where a beat feels right. Match density to post type (Step 1). Single-line standalone sentences should be reserved for moments where the line genuinely needs to land alone — gut-punches, pivots, closers.

### Lists

If the content has a numbered list or series of points, space them out. Keep the user's original numbering if present. For unnumbered series, add markers (→, •, or ↳).

**Before:**
```
Things I learned: 1. The best engineers ask the right questions. 2. Clients care about outcomes. 3. Remote teams work if you hire for ownership.
```

**After:**
```
Things I learned:

1. The best engineers ask the right questions.

2. Clients care about outcomes.

3. Remote teams work if you hire for ownership.
```

### Emojis

Use 0-3 per post. Place as section anchors or to mark the start/end, not on every line. Match tone — a serious or reflective post gets 0, a celebratory one can have 2-3. If the user already included emojis, keep them exactly as placed.

### Hashtags

Add 3-5 relevant hashtags at the very end, separated from the body by a blank line. Mix broad (#Leadership, #AI) and niche (#FounderLife, #B2BSaaS). If the user already has hashtags, keep them as-is (cap at 5). Hashtags are the one addition that isn't in the original content.

## Step 3: De-AI check (offered after formatting if needed)

After formatting, scan the post for AI tells. If you spot any, ask the user before delivering:

> "I noticed a few things that might make this read as AI-written: [list]. Want me to suggest fixes, or is the current voice intentional?"

Common AI tells to scan for:

- **Em-dashes (—) used heavily.** A handful is fine; more than 3-4 in a short post is a giveaway. Replace with commas, periods, or rewritten phrasing.
- **Parallel-structure triplets.** "It's X. It's Y. It's Z." stacked rhythmically. One per post is fine; two close together is a tell.
- **Polished generic phrasing.** "I haven't been able to shake it" beats "It has been on my mind." "Some days I feel it too" beats "This resonates with me."
- **Vague time markers.** "Recently" is a tell. "Last week" or "yesterday" sounds human.
- **No admissions or hedges.** Real people say "I think," "honestly," "I might be wrong," "it took me years." Pure declarative confidence reads as AI.
- **Even cadence with no fragments.** Humans drop sentence fragments. "Honestly?" alone. "I did." alone. AI tends to write complete sentences throughout.
- **Overuse of "actually," "really," "genuinely," "truly."** These are filler intensifiers. More than 2 instances of any one of them is worth flagging.
- **Lecture-mode pronouns.** Heavy "you" can sound preachy. Switching to "we" at the right moment pulls the writer in alongside the reader.

When proposing fixes, be specific: quote the exact phrase and offer 1-2 alternatives. Don't apply changes until the user picks one.

## Step 4: Self-review pass (offer before final delivery)

Before saving the final file, offer a review:

> "Want me to do a quick review pass for repetitions and rough spots?"

If accepted, scan for:

- **Word repetitions.** Count how many times these appear: "actually," "really," "honestly," "just," "literally," "obviously," "basically." Three or more of any one of these is worth flagging. Also flag any unusual word that appears 3+ times unintentionally.
- **Phrase repetitions.** Same construction repeated: "the part that...," "the thing is...," "the way I think about it is...". Flag if 2+ instances appear close together.
- **Hedge stacking.** "I think maybe possibly..." Pick one hedge.
- **Triplet density.** Two parallel-structure triplets within 4 paragraphs of each other. Suggest breaking one.
- **Adjacent paragraph repetition.** Same opening word/phrase in consecutive paragraphs ("And...", "But...", "Honestly...").
- **Closing strength.** Does the last line land? If it trails off into a generic CTA or vague gesture, flag it.

For each issue found, propose a specific fix with the original and the alternative side by side. User picks. Apply only after approval.

## Handling code samples

LinkedIn doesn't support code blocks or monospace fonts. Inline code in a post looks bad and is hard to read. When the user's content contains code (commands, snippets, config, terminal output), extract it into a visual image and keep the post text clean.

### How to handle code

1. **Identify code** in the user's content — terminal commands, code snippets, config blocks, CLI output, file paths used as commands, etc.
2. **Remove code from the post text.** Keep the surrounding prose descriptions (e.g., "This removes the file from every commit" stays, but `git filter-repo --invert-paths ...` goes). End the description with a period instead of a colon if the code that followed the colon is removed.
3. **Build an HTML code card** using the template at `assets/code-card-template.html`. Read the template, then:
   - Replace `__TITLEBAR_TEXT__` with a contextual label (e.g., `~/your-repo — bash`, `config.yaml`, `Python 3.12`).
   - Replace `__CODE_CONTENT__` with the code formatted into `<div class="step">` blocks. Use these CSS classes for syntax highlighting:
     - `.comment` — for step labels/comments (prefix with `#`)
     - `.prompt` — for `$ ` shell prompts
     - `.command` — for the command text
     - `.flag` — for flags like `--force`, `--path`
     - `.path` — for file paths and placeholders like `<commit-hash>`
     - `.url` — for URLs and remote addresses
     - `.string` — for string literals
     - `.keyword` — for language keywords
     - `.output` — for terminal output (italic grey)
   - Group related commands under a comment header in each `.step` div.
4. **Convert to PNG** using wkhtmltoimage:
   ```bash
   wkhtmltoimage --enable-local-file-access --width 800 --quality 95 code-card.html code-card.png
   ```
5. **Copy the PNG to clipboard** so the user can paste it directly into LinkedIn's image upload. Use one of the available clipboard tools — if `xclip` is available:
   ```bash
   xclip -selection clipboard -t image/png -i code-card.png
   ```
   If xclip isn't available, try `xsel` or `pbcopy` (macOS). If no clipboard tool works, present the file for download instead.

### Output

When code samples are present, deliver two files:

- A `.txt` file with the formatted post text (code removed, descriptions kept)
- A `.png` file with the code card image (also attempt clipboard copy)

Always output as files — never output the formatted post as inline chat text, because line breaks get lost when copying from chat.

## Boundaries

Do NOT silently rewrite, rearrange, or rephrase content. The de-AI pass and self-review pass propose changes for approval — they never apply changes silently.

Do NOT rearrange sentence order, add a "hook" by moving content to the top, add CTAs or engagement bait ("Agree? 👇"), add words or sentences not in the original (except hashtags, and approved edits from the optional passes), use Unicode faux-bold/italic (𝗧𝗵𝗶𝘀 𝘀𝘁𝘆𝗹𝗲), or split a sentence mid-thought in a way that breaks meaning.

The one exception to "no removal": when extracting code into an image, removing the code lines from the post body is expected — keep all the prose intact.

## Applying the skill

1. Read the content. Detect post type (punchy / reflective / mixed). Check for code samples.
2. Format. Apply spacing density matching the post type. Add markers, emojis, hashtags. No word changes.
3. De-AI check. Scan for AI tells. If present, ask the user before changing anything.
4. Apply approved de-AI fixes if any.
5. Offer self-review pass. If user accepts, scan for repetitions and rough spots, propose fixes, apply approved ones.
6. Save and deliver. Always save as `.txt` (and `.png` if code is present) in the outputs directory. Never output the formatted post as inline chat text — line breaks get lost when copying from chat.
7. Verify. Before delivering, confirm that all words appearing in the final output match either the user's original content or edits the user explicitly approved.
