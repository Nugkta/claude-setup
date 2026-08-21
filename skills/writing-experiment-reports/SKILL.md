---
name: writing-experiment-reports
description: Use when the user asks to write up, summarize, or report on a completed experiment, run, or analysis (phrases like "write a report", "summarize the results", "writeup", "findings on X", "html report"). Detects depth (brief vs comprehensive) and destination (chat, markdown file, or HTML file) from natural phrasing. Counters Claude Code's brevity bias — reports are deliverables, not conversational replies.
---

# Writing Experiment Reports

## Overview

After a set of experiments completes, the user wants a structured **deliverable** — not a terse chat reply. Length and structure take priority over default brevity.

This skill enforces:
1. **Four required sections in order**: Motivation → Design → Results → Analysis
2. **Mode detection** from natural phrasing — no flags required
3. **Brevity-bias override** — reports are not conversational responses

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

## Required Structure (all four, in order)

Every report — chat or file, brief or comprehensive — must include these four sections in this order:

1. **Motivation** — Why this experiment? What question or hypothesis? What gap or prior result motivated it?
2. **Design** — What was done? Models, data, splits, metrics, hyperparameters, protocol, hardware/seeds where relevant.
3. **Results** — Numerical findings. Use tables when comparing ≥2 conditions. Cite plot/file paths.
4. **Analysis** — What the results mean. Caveats, surprises vs expectations, limitations, follow-ups.

Do **not** rename, merge, reorder, or omit sections. A report missing any of these is incomplete. "Motivation is obvious" is not an excuse — write one sentence, but write it.

Also, high level explanation is critical. Include the overarching picture from the start.

## Depth Targets

### Brief mode (~150–300 words)
- High level overall picture explanation
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

## Brevity-Bias Override (CRITICAL)

Claude Code's defaults favor terse responses. **Reports are the exception.**

| Default behavior | Override for reports |
|---|---|
| "Be concise" | Be complete |
| Skip section headers | Always use the four headers |
| Bullets over prose | Use prose for Motivation/Analysis; tables for Results |
| "Avoid trailing summaries" | The whole task IS a summary — no apologetic trailer, but the body is full |
| Match response length to question complexity | Match length to **mode**, not to question phrasing |

- DO necesssary research to support the the explanation of designs and results. Don't skip the work just because the question is short.

If the user asks "can you write a report on X" — the question is short, but the answer must not be. Treat report requests as deliverables.

## Markdown File Mode — Extra Rules

When writing to a `.md` file:
- `# Title` (H1) at top, descriptive (e.g. `# Phase W: T2 fewshot follow-up`)
- `## Motivation`, `## Design`, `## Results`, `## Analysis` for the four headers
- Date and run-id/branch at the top if knowable from context
- Proper markdown tables (pipes), not ASCII art
- Cross-link other files with relative paths
- After writing, print a one-line chat confirmation with the path

## HTML File Mode — Extra Rules

HTML mode is for when the report deserves a richer presentation than plain markdown — better-styled tables, embedded figures with captions, side-by-side plot grids, optional math via MathJax, and a clickable table of contents. Use it whenever the user asks for an "html report", "html interface", "interactive report", "rendered report", or gives a `.html` path.

A starter template lives next to this skill at `~/.claude/skills/writing-experiment-reports/template.html`. Copy it to the target path, then fill in the four sections. The template is a **single self-contained file** (inline CSS, no external dependencies) — works offline, opens in any browser.

Required structure:
- `<!DOCTYPE html>` with `<meta charset>` and `<meta viewport>`
- `<title>` matching the report title
- Inline `<style>` block (use the template's CSS — don't reinvent)
- `<h1>` title at top, `<div class="meta">` line with date / branch / author
- `<div class="toc">` with anchor links to the four sections
- `<h2 id="motivation">`, `<h2 id="design">`, `<h2 id="results">`, `<h2 id="analysis">` — same four sections, same order, with id anchors

Tables (use `<table>` with `<thead>` / `<tbody>`):
- Add `class="num"` to numeric `<th>` and `<td>` cells for right-aligned tabular numerals
- Wrap best results in `<strong>` to draw the eye
- Don't paste raw markdown tables — convert them

Figures:
- `<figure><img src="..."><figcaption><strong>Figure N.</strong> caption</figcaption></figure>`
- For comparing 2+ plots side-by-side, wrap them in `<div class="figure-grid">` (CSS grid auto-fits)
- Use **relative paths** to figures (`../../results/.../plot.png`) so the report stays portable inside the repo. Only inline as base64 if the user asks for a single-file portable report.

Equations (optional):
- Uncomment the MathJax `<script>` line in the template. Then write LaTeX inline as `\(x^2\)` or block as `$$...$$`.

Code blocks: use `<pre><code>...</code></pre>`. The template styles them with a monospace font and subtle background.

Callouts: `<div class="callout">...</div>` for key takeaways, `<div class="callout warning">...</div>` for caveats.

After writing, print one-line confirmation: `Wrote HTML report to <path>. Open with: xdg-open <path>` (or the user's local equivalent).

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

- **Skipping Motivation** — jumping straight to results. Always start with why.
- **Merging Results into Analysis** — keep numbers (Results) separate from interpretation (Analysis).
- **Defaulting to brief** — if depth is ambiguous, default comprehensive.
- **Silently writing a file** — always confirm in chat with the path.
- **Reordering sections** — Motivation → Design → Results → Analysis is non-negotiable.
- **Conversational framing** — no "Sure, here's a quick report..." preamble, no "let me know if..." trailer inside the report body.
- **Asking for clarification on mode** — infer from phrasing; only ask if information about the experiment itself is missing.

## Red Flags — STOP

If you find yourself thinking:

| Thought | Reality |
|---|---|
| "This question is short, so my answer should be short" | Mode is set by phrasing, not question length. |
| "I'll skip Motivation since it's obvious" | Every section is required. One sentence is fine, zero is not. |
| "I'll just give bullet points" | Prose for Motivation/Analysis; tables for Results. |
| "The user can ask for more detail if they want" | Default is comprehensive. Over-deliver. |
| "I should ask whether they want brief or comprehensive" | Infer from phrasing. Don't ask. |
| "It's just a chat report so I can be loose" | Same four sections, same order, chat or file. |

All of these mean: re-read the four required sections and the depth target for the detected mode.
