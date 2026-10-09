# AI Engineer Scoring Criteria (calibrated)

This rubric assigns each candidate a Score from 1-10 and a Recommendation (Strong Yes / Yes / Maybe / No / Strong No). The role is for an **AI Engineer building agents and Generative AI in production** — not frontend, backend, or infrastructure.

The rubric has been calibrated against real candidates the user reviewed and approved. The anchors below are anonymised composites that preserve the scoring-relevant shape of those profiles. Apply them — if a new candidate clearly falls between two anchors, give them the in-between score.

## Calibration anchors (do not change without re-calibration)

### Score 8 — Anchor A
- Top-tier engineering grad (IIT), ~1.5 years experience (slightly under sweet spot)
- Currently at a **well-known YC-backed small/mid AI startup**
- Prior: tech lead at an early-stage startup for ~1.5 years
- **Substantive GenAI work**: LoRA fine-tuned a 7B open model with GRPO (large accuracy jump, e.g. 70s→90s %), published to HuggingFace, set up production inference, automated an eval pipeline. Cut an AI product's latency ~5x
- Strong achievements: top competitive-coding rank at college, top-percentile entrance exam, multiple international research internships
- Initiative: led the college entrepreneurship cell, organised a flagship campus event

**Why 8 not 9**: YOE on the low end; lacks a standout open-source artifact or singular high-impact "wow" moment that would push to outstanding.

### Score 6 — Anchor B
- 3.5 years experience, **all at a large Indian industrial conglomerate** (one with a technology-services arm, e.g. L&T)
- 3 promotions visible: Associate Engineer → Engineer → AI Engineer
- **Substantive agentic work**: multi-agent LangGraph supervisor-worker system with MCP tools for an internal business unit (claims ~4x latency reduction, measurable monthly cost savings, FTEs replaced). RAG system serving 1000+ internal users. Custom MCP servers connecting Claude Code to internal APIs.
- Modern stack: LangGraph, MCP, CrewAI, Agno, Google ADK, LlamaIndex evaluated

**Why 6 not 7**: A large traditional conglomerate, not a fast-growing funded startup — moderate penalty. Resume reads very polished/possibly AI-formatted, raising slight authenticity question. No public GitHub presence shown for the work claims.

### Score 5 — Anchor C
- 3 years experience, **currently at a cap-list service company** (e.g. Accenture) in an AI/ML analyst role, joined recently
- Claims strong production metrics: large hallucination reduction, 100K+-doc semantic search, multi-agent CrewAI orchestration, framework migration boosting accuracy by 20+ points
- Personal project: small consumer AI app (~100 DAU at peak)

**Why 5 (capped)**: **The current employer is a service company — hard cap at 5 regardless of how strong the claimed metrics are**. Client-services delivery work is fundamentally different from product ownership at a funded startup, even when the technical substance is real. The cap exists because the cultural mismatch and lack of product ownership signal outweigh the technical claims. Also: prior work history shows only one internship — a multi-year gap unaccounted for, which deepens the concern.

## Service-company hard cap rule

If a candidate's CURRENT role or **majority of recent experience** is at any of these companies, **score is capped at 5** regardless of claimed work substance:

- Accenture
- TCS (Tata Consultancy Services)
- Infosys
- Wipro
- Cognizant
- Capgemini
- HCL Technologies
- LTI / LTIMindtree
- Mphasis
- Tech Mahindra
- Persistent Systems
- Mindtree
- Hexaware
- Birlasoft

Why: client-services culture, no product ownership, candidates often present client work as if it were their own, and very low conversion rate from such backgrounds historically.

**Adjacent companies (moderate penalty, not a cap)**:
- L&T / L&T Technology Services (large industrial conglomerate with services arm) — score capped at 6-7 unless exceptional
- Tata Elxsi / Tata Consultancy Services subsidiaries — capped at 5-6
- Daffodil Software / Unthinkable Solutions — services-adjacent, capped at 7
- Tudip Technologies — similar profile, capped at 5-6

When in doubt, look at: do they own a product, or do they execute client engagements? Product ownership = no cap, services delivery = cap applies.

## Scoring scale (be strict; avoid grade inflation)

| Score | Recommendation | Description |
|-------|---------------|-------------|
| **9-10** | Strong Yes | **Outstanding (rare)** — strong GenAI production at a known funded startup + great GitHub depth + a standout achievement (high-impact OSS, strong publication, top achievement) |
| **8** | Yes | **Strong yes** — proven GenAI production at a real startup, right YOE OR exceptional initiative signals. See Anchor A. |
| **7** | Yes | **Yes (one gap)** — solid GenAI substance but missing one of: ideal YOE, startup quality, GitHub depth |
| **6** | Maybe | **Maybe** — real agentic/GenAI substance but at non-startup OR strong fundamentals with weak GenAI specificity. See Anchor B. |
| **5** | No | **Lean no** — service company cap, OR tutorial-grade GenAI, OR fundamental fit gap. See Anchor C. |
| **4** | No | **No** — service-co default w/ weak signals, no real GenAI, weak initiative, breadth-without-depth GitHub |
| **3** | Strong No | **Strong no** — fresher with tutorial-only GenAI, OR no resume + no verifiable links, OR pure non-GenAI background |
| **1-2** | Strong No | **Strong no** — wrong role entirely, completely insufficient evidence |

Recommendation mapping (always apply):
- 9-10 → "Strong Yes"
- 7-8 → "Yes"
- 6 → "Maybe"
- 4-5 → "No"
- 1-3 → "Strong No"

## Positive signals (move score up)

- 2-4 years professional experience (the sweet spot)
- Production GenAI shipping with **real quantified metrics** (latency reduced from X→Y, accuracy moved A→B, scale: N daily users / K documents)
- Funded fast-growing startup (10+ people, ideally YC/known investors, not too large)
- Multiple internal promotions at one company
- Strong GitHub: meaningful side projects, real agent/LLM repos with substance (not single-commit shells), recent activity
- Initiative signals: hackathons, OSS contributions, blogs/talks, custom portfolio site (not template), multiple research internships
- Genuine cover letter with unique perspective (NOT AI-generated boilerplate)
- IIT/IIIT/BITS/NIT/IISc top-tier pedigree (mild positive; not required)
- Tinkerer signals: built things outside work because they wanted to (open-source tools, side experiments, scratch implementations)

## Negative signals (move score down)

- Service company current role (hard cap, see above)
- Pure frontend / backend / DevOps / infra focus despite "AI Engineer" title
- Too many short job switches (3+ jobs in 2 years)
- Tutorial-grade GenAI work only (single-file LangChain demo, generic "RAG with OpenAI API" textbook project)
- AI-generated cover letter (telltale: em-dashes everywhere, perfectly structured tables, generic phrasing, too-clean metrics)
- Wrong YOE shape: <1 year full-time (too junior unless exceptional) OR >7 years (potentially overqualified for the role's seniority shape)
- Resume gap unexplained (multi-year period with no role listed)
- GitHub linked but profile is empty / no AI-relevant repos / only tutorial forks
- Strongly research-oriented (PhD with no production shipping) — the role wants engineers, not researchers
- Application that arrived from generic job boards (Cutshort outreach response, Instahyre auto-apply) without a tailored cover letter

## How to write the Score Reason

2-4 sentences. Lead with the strongest signal. Be specific — name companies and projects. Reference the anchor when relevant ("comparable to Anchor B but with stronger metrics, nudging above").

**Good example**:
> "Top-tier engineering degree + genuinely substantive inference optimization (QLoRA fine-tuning, vLLM/Triton/CUDA, serving a domain-tuned 7B model) is real depth above tutorial level. However the focus is model-serving / training optimization rather than the agents-in-production sweet spot for this role. Current employers (a small AI lab as contractor, an early-stage startup as intern) are small/unknown — not 10+-person funded startups. About to start a Masters abroad, raising availability concerns."

**Bad example** (too generic, no specifics):
> "Strong candidate with good ML background. Has experience with LLMs and agents. Would be a good fit for the role."

## Profile Summary body block format

After scoring, prepend this block to the page body using `command="insert_content"` with `position={"type":"start"}`:

```markdown
## Profile Summary
- **Years of Experience**: <e.g., "~3.5 years full-time, all at one conglomerate">
- **Companies & Type**: <e.g., "Large industrial conglomerate (has a services arm). Prior internal moves within the same group.">
- **Promotions / Trajectory**: <e.g., "3 promotions visible: Associate Engineer → Engineer → AI Engineer">
- **GitHub Activity**: <e.g., "github.com/USERNAME — small public footprint; production work lives in employer repos">
- **Notable**: <e.g., "Multi-agent LangGraph supervisor-worker with MCP tools. Custom MCP servers connecting Claude Code to internal APIs (strong tinkerer signal).">
- **Red Flags**: <e.g., "Large conglomerate, not fast-growing startup. Resume reads very polished — possibly AI-formatted.">
```

Score Reason ≠ Profile Summary. Score Reason explains **why this score**; Profile Summary gathers raw factual signals (don't duplicate text between them).
