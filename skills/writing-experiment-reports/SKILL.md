---
name: writing-experiment-reports
description: Use when the user asks to write up, summarize, or report on a completed experiment, run, or analysis (phrases like "write a report", "summarize the results", "writeup", "findings on X", "html report"). Detects depth (brief vs comprehensive) and destination (chat, markdown file, or HTML file) from natural phrasing. Reports tell the study as a story in the order the user actually worked, in plain complete sentences that a colleague can read once and understand. Counters Claude Code's brevity bias — reports are deliverables, not conversational replies.
---

# Writing Experiment Reports

## Overview

After a set of experiments completes, the user wants a structured **deliverable** — not a terse chat reply. Length and structure take priority over default brevity, and **readability takes priority over density**.

This skill enforces:
1. **Five required sections in order**: Overview → Motivation → Design → Results → Analysis
2. **The user's own storyline** as the backbone of every section
3. **Plain, complete sentences** — no compressed jargon, no parenthetical asides
4. **Mode detection** from natural phrasing — no flags required
5. **Brevity-bias override** — reports are not conversational responses

## Readability rules (CRITICAL — the most common failure)

A report that is dense but unreadable is a failed report. These rules were written after a report came back with the comment "全都是那种只言片语的句子 … 根本看不懂" ("nothing but fragments … impossible to understand"). Apply them to every sentence.

**Write for a colleague who knows the field but did not watch you work.** They read the report once, top to bottom, without the conversation in front of them.

1. **Complete sentences with a subject and a verb.** Not "Descriptions: first-order variable for json (6 F1), second-order for inline." But: "The entity descriptions matter a lot for the json answer and little for the inline answer. Four wordings moved the json score by 6 points."
2. **No parenthetical asides carrying the meaning.** If something in brackets is important, make it its own sentence. If it is not important, delete it. A sentence like "json beats inline (5/7 tasks, +4.1 mean; recall-driven, see §3)" must become three sentences.
3. **Define every term the first time it appears.** "inline" and "json" are meaningless until the reader is told that one rewrites the sentence with tags and the other returns a JSON object. Do this in the Overview, in one sentence each, before using the terms.
4. **One idea per sentence, about 20 words.** Split anything longer.
5. **No reference-style compression.** No "cf.", no "vs" inside prose, no "≈", no "→" chains, no "P/R/F1" slashes in sentences. Arrows and slashes belong in tables.
6. **Say what a number means, not just what it is.** "Our json score is 46.7, ten points above the paper's 36.8" — then the next sentence says whether that is good, bad, or suspicious.
7. **Explain a method before its result.** The reader must know what an experiment did before being told what it found.
8. **Bold sparingly**: the first few words of a paragraph or list item, never a whole sentence, never inside a table cell except the best score.
9. **Tables hold numbers; prose holds meaning.** Do not paste a table and leave the reader to interpret it. Every table is followed by one to three sentences saying what to take from it.
10. **Read the Overview aloud before finishing.** If any sentence would sound strange spoken to a colleague, rewrite it.

Bad → good, from a real case:

| Bad (what was written) | Good (what it should have been) |
|---|---|
| "Entity descriptions are a first-order variable for json (6.1 F1 across four wordings, all of it precision) and a second-order, even negative, one for inline (long rule text costs 3 F1)." | "The entity descriptions in the prompt matter a lot for the json answer and very little for the inline answer. Changing only the description wording moved the json score by 6 points, and all of that change was in precision. For inline, a long description actually made the score 3 points worse." |
| "Runner validated. On CoNLL++ inline lands 1.5 under the paper's in-line Mixtral row (37.7 vs 39.2); json above (46.7 vs 36.8)." | "The MNEB implementation reproduces the paper. On CoNLL++ our inline score is 37.7, within 1.5 points of the paper's 39.2. Our json score is 46.7, ten points above the paper's 36.8, and the rest of this report explains where those ten points come from." |

## The storyline rule

Every study has a storyline: the sequence of things the user set out to do and what each step led to. **The report follows that sequence**, not the chronological mess of jobs, bugs, and reruns, and not a generic template order.

Before writing, extract the storyline as three to five numbered steps in the user's own logic. Example from a reproduction study:

1. The method has two answer shapes, inline and json; run both on our benchmark.
2. The paper only reports CoNLL, so add CoNLL++ and compare against the paper.
3. The json score came out higher than the paper; find out why (it was the prompt descriptions), confirm everything else matches.
4. With the runner confirmed, run the leaderboard datasets and add the method to the leaderboard.

Then:
- The **Overview** tells these steps as a short numbered list, one or two sentences each, followed by the headline numbers.
- **Design** and **Results** use the same steps as subsections, in the same order, with the same names.
- **Analysis** answers, step by step, what each finding means.
- Side discoveries (a bug found on the way, a tooling fix) get their own short subsection and do not interrupt the storyline.

If the storyline is not clear from the conversation, ask the user one question: "What were the steps you set out to do, in order?" Do not guess a structure from the files.

## Mode Detection

Detect both axes from the request before writing. Do **not** ask — infer and proceed.

### Destination: chat vs markdown file vs HTML file

| User says... | Destination |
|---|---|
| "to `path/file.md`", "save as markdown", "put it in the labbook", "append to docs/...", "create a writeup in ..." | **markdown file** |
| "to `path/file.html`", "as html", "html report", "html interface", "interactive report", "browser-friendly", "rendered report", "with figures embedded" | **html file** |
| (no destination cue) | **chat** |

When destination is any file (markdown or HTML), **also** print a one-line confirmation in chat ("Wrote report to `path/file.html`"). Never silently write a file.

If the user gives a path with `.html` extension or asks for an HTML/rendered/browser-friendly report, use HTML mode. If they give a path with `.md` extension or mention markdown/labbook, use markdown mode.

### Depth: brief vs comprehensive

| User says... | Depth |
|---|---|
| "brief", "short", "quick", "summary", "TL;DR", "high-level", "in a paragraph" | **brief** |
| "comprehensive", "detailed", "full", "thorough", "writeup", "in detail", "complete report" | **comprehensive** |
| (ambiguous — just "report" or "summarize") | **comprehensive** (default — reports are deliverables) |

If you cannot tell, default to **comprehensive**. Don't ask — over-deliver.

## Required Structure (all five, in order)

Every report — chat or file, brief or comprehensive — must include these five sections in this order:

1. **Overview** — One short paragraph saying what the method or system is, in words a newcomer understands. Then the storyline as a numbered list (see above). Then a short bullet list of headline numbers. A reader who stops here walks away with the whole story. In brief mode, the paragraph and the numbers only.
2. **Motivation** — Why this study? What question or hypothesis? What gap or prior result motivated it? Prose.
3. **Design** — What was done, organised by storyline step. Models, data, splits, metrics, hyperparameters, protocol, hardware where relevant. A compact "common setup" table is fine; the steps themselves are prose.
4. **Results** — Numbers, organised by the same storyline steps. Tables when comparing two or more conditions, each followed by sentences that say what to take from it. Cite plot and file paths.
5. **Analysis** — What the results mean, step by step. Then caveats, surprises versus expectations, limitations, follow-ups. Prose, no bullet dumps.

An optional **Appendix** after Analysis may collect questions the user asked during the study, each answered in a short paragraph.

Do **not** rename, merge, reorder, or omit the five sections. "Motivation is obvious" is not an excuse — write one sentence, but write it.

## Depth Targets

### Brief mode (~150–300 words)
- Overview: what the thing is in one sentence, headline finding in one or two
- 1–3 sentences per section
- Headline numbers only (no full tables unless ≤3 rows)
- Skip hyperparameter dumps; note "see config" if relevant
- Analysis = 2–3 takeaways, no exhaustive caveats

### Comprehensive mode (~600–1500+ words)
- Full paragraphs per section, prose for Motivation and Analysis
- Tables for all numerical comparisons (proper markdown tables, not ASCII)
- Document hyperparameters, splits, seeds, hardware where relevant
- Analysis covers: what numbers mean, why surprising/expected, limitations, follow-ups
- Cite file paths — `scripts/foo.py`, `results/.../plot.png`, `docs/labbook/...`

Longer is not better. A 3,000-word report that repeats the same numbers in three tables is worse than a 1,500-word one that says each thing once, clearly.

## Brevity-Bias Override (CRITICAL)

Claude Code's defaults favor terse responses. **Reports are the exception.**

| Default behavior | Override for reports |
|---|---|
| "Be concise" | Be complete — and be clear. Completeness never excuses fragments. |
| Skip section headers | Always use the five headers |
| Bullets over prose | Use prose for Motivation/Analysis; tables for Results; bullets only for parallel items |
| "Avoid trailing summaries" | The whole task IS a summary — no apologetic trailer, but the body is full |
| Match response length to question complexity | Match length to **mode**, not to question phrasing |

- Do the necessary research to support the explanation of designs and results. Don't skip the work just because the question is short.

If the user asks "can you write a report on X" — the question is short, but the answer must not be. Treat report requests as deliverables.

## Markdown File Mode — Extra Rules

When writing to a `.md` file:
- `# Title` (H1) at top, descriptive (e.g. `# Phase W: T2 fewshot follow-up`)
- `## Overview`, `## Motivation`, `## Design`, `## Results`, `## Analysis` for the five headers
- Date and run-id/branch at the top if knowable from context
- Proper markdown tables (pipes), not ASCII art
- Cross-link other files with relative paths
- After writing, print a one-line chat confirmation with the path

## HTML File Mode — Extra Rules

HTML mode is for when the report deserves a richer presentation than plain markdown — better-styled tables, embedded figures with captions, side-by-side plot grids, optional math via MathJax, and a clickable table of contents. Use it whenever the user asks for an "html report", "html interface", "interactive report", "rendered report", or gives a `.html` path.

A starter template lives next to this skill at `~/.claude/skills/writing-experiment-reports/template.html`. Copy it to the target path, then fill in the five sections. The template is a **single self-contained file** (inline CSS, no external dependencies) — works offline, opens in any browser.

Required structure:
- `<!DOCTYPE html>` with `<meta charset>` and `<meta viewport>`
- `<title>` matching the report title
- Inline `<style>` block (use the template's CSS — don't reinvent)
- `<h1>` title at top, `<div class="meta">` line with date / branch / author
- `<div class="toc">` with anchor links to the five sections
- `<h2 id="overview">`, `<h2 id="motivation">`, `<h2 id="design">`, `<h2 id="results">`, `<h2 id="analysis">` — same five sections, same order, with id anchors
- Storyline steps as `<h3>` subsections inside Design and Results, same names in both

Tables (use `<table>` with `<thead>` / `<tbody>`):
- Add `class="num"` to numeric `<th>` and `<td>` cells for right-aligned tabular numerals
- Wrap best results in `<strong>` to draw the eye
- Don't paste raw markdown tables — convert them
- Round to what the reader needs: one decimal for F1-style scores unless the comparison hinges on the second decimal

Figures:
- `<figure><img src="..."><figcaption><strong>Figure N.</strong> caption</figcaption></figure>`
- For comparing 2+ plots side-by-side, wrap them in `<div class="figure-grid">` (CSS grid auto-fits)
- Use **relative paths** to figures (`../../results/.../plot.png`) so the report stays portable inside the repo. Only inline as base64 if the user asks for a single-file portable report.

Equations (optional):
- Uncomment the MathJax `<script>` line in the template. Then write LaTeX inline as `\(x^2\)` or block as `$$...$$`.

Code blocks: use `<pre><code>...</code></pre>`. The template styles them with a monospace font and subtle background. A prompt shown to a model, or a raw model output, belongs in a code block, not in prose.

Callouts: `<div class="callout">...</div>` for key takeaways, `<div class="callout warning">...</div>` for caveats.

After writing, print one-line confirmation: `Wrote HTML report to <path>. Open with: xdg-open <path>` (or the user's local equivalent).

## Final checklist before delivering

- [ ] The Overview opens by saying what the method or system **is**, before any result.
- [ ] The storyline is a numbered list in the Overview and the same steps head Design and Results.
- [ ] Every term of art (answer shape names, dataset variants, metric names) is defined at first use.
- [ ] No sentence carries its meaning inside brackets.
- [ ] No "vs", "≈", "→", "P/R/F1" inside prose.
- [ ] Every table is followed by a sentence saying what it shows.
- [ ] Each number appears with its comparison point and a plain statement of whether it is good or bad.
- [ ] Reading the Overview aloud sounds like explaining the study to a colleague.

## Quick Reference

```
User intent                              → Mode
─────────────────────────────────────────────────────────────────
"write a report on X"                     → chat + comprehensive
"brief summary of X"                      → chat + brief
"write the report to foo.md"              → markdown + comprehensive
"save a quick summary to bar.md"          → markdown + brief
"full writeup in the labbook"             → markdown + comprehensive
"render an html report to out.html"       → html + comprehensive
"quick html summary at /tmp/report.html"  → html + brief
"interactive report with figures"         → html + comprehensive
"summarize the results"                   → chat + comprehensive (default)
"draft the labbook entry for phase W"     → markdown + comprehensive
```

## Common Mistakes

- **Fragments instead of sentences** — "json > inline (5/7)" is a note to yourself, not a report. Write the sentence.
- **Jargon before definition** — using the study's shorthand (answer-shape names, variant names) before saying what they are.
- **Template order instead of the user's order** — listing results by dataset when the user's logic was by step.
- **Skipping Motivation** — jumping straight to results. Always start with why.
- **Merging Results into Analysis** — keep numbers (Results) separate from interpretation (Analysis).
- **Defaulting to brief** — if depth is ambiguous, default comprehensive.
- **Silently writing a file** — always confirm in chat with the path.
- **Reordering sections** — Overview → Motivation → Design → Results → Analysis is non-negotiable.
- **Conversational framing** — no "Sure, here's a quick report..." preamble, no "let me know if..." trailer inside the report body.
- **Asking for clarification on mode** — infer from phrasing; only ask if information about the experiment itself (such as the storyline) is missing.

## Red Flags — STOP

If you find yourself thinking:

| Thought | Reality |
|---|---|
| "This question is short, so my answer should be short" | Mode is set by phrasing, not question length. |
| "I'll pack more facts into this sentence with brackets" | Every bracket is a sentence you owe the reader. Write it. |
| "The reader knows what 'inline' means by now" | The reader was not in the conversation. Define it. |
| "I'll skip Motivation since it's obvious" | Every section is required. One sentence is fine, zero is not. |
| "I'll just give bullet points" | Prose for Motivation/Analysis; tables for Results. |
| "The user can ask for more detail if they want" | Default is comprehensive. Over-deliver. |
| "I should ask whether they want brief or comprehensive" | Infer from phrasing. Don't ask. |
| "It's just a chat report so I can be loose" | Same five sections, same order, chat or file. |

All of these mean: re-read the readability rules, the storyline rule, and the depth target for the detected mode.
