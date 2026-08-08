- Use the UV environment, update when new modules installed.
- Use subagents more, and different capability agents for different levels of tasks. Only use the main stream for the main task.
   - For implementation and coding tasks, use Sonnet 5 agents.
   - For planning, audit, report writing, analysis, and interpretation, use Fable agents.

## Delegation policy — fable-specialist

The main Opus 4.6 agent coordinates conversation and delegates to specialists.

**Auto-delegate to Fable when the task involves:**
- Architecture design, system-level planning, or brainstorming
- Scientific reasoning, hypothesis evaluation, or experimental design
- Code audit, security review, or performance analysis
- Report writing, results interpretation, or research narrative
- High-stakes decisions where getting it wrong is costly

**Auto-delegate to Sonnet 5 when the task involves:**
- Substantial new implementation (>50 lines, multi-file, or tricky logic)
- Hard debugging requiring root-cause analysis across multiple components
- Refactoring, optimization, or code migration

**Do NOT delegate when the task is:**
- Explanations, follow-ups, or answering questions about prior work
- Simple edits, one-liner fixes, or config changes
- Summarization, clarification, or ordinary conversation
- Labbook updates or documentation-only changes
- Tasks the user explicitly asked you to handle directly

**How to handle results:**
- Integrate the specialist's findings into the conversation — synthesize, don't just forward raw output.
- If the specialist proposes code changes, review them before presenting to the user.
- The user should experience a seamless conversation, not feel like they're talking to two agents.
- when running light scripts and test, use similar command to 'srun --partition=interactive --reservation=interactive --gres=gpu:1 --time=8:00:00 --pty bash' (limit is 8 hours, 4 gpu for the interactive partition) (can also do sbatch)
   - only when running really heavy jobs, use sbatch with workq partition
   - never run heavy jobs on the login node!! including the tests (tell subagents this!!!!)
- remove the short investigation files after using them.
- always update the README after any progress made.
- monitor the sbatch submitted files to fix bug if it failed.
- never write implementation/diagnosis reports .md, just reply in the chat briefly.
- when I say discuss interactively on something (like research plan), use more AskUserQuestion.
- Try to use straightforward and clear language when I'm asking you to explain anything or when you are reporting things to me. Make some efforts to make sure Your output is reasonable in terms of the language use. 
- Always update labbook when you have a long task and you are waiting for the queue or the task to finish.
- Refer to labbook for information first.
- if the training of the model takes a long time, try optimising it first.


## Documentation Standardss

1. **Root-level main markdown**: Any functional, architectural, or code updates MUST update relevant subdirectory documentation after work completion.

2. **Every folder MUST have a README.md with**:
   - Concise architecture description (≤3 lines)
   - List of each file with: name, status, and function
   - Header declaration: "Once my folder has changes, please update me."

3. **Every file MUST have header comments**:
   - **Input**: External dependencies (what this file needs)
   - **Output**: What it provides externally (what others use from this)
   - **Pos**: Role/position in the local system architecture
   - Reminder: "Once I am updated, update my header comments and folder's md."




## Lab Notebook Protocol
1. **`docs/metalabbook.md`** — single index table for ALL studies. Columns:
   `Slug | Status (active/done/abandoned) | Started | Last Updated | One-line Summary`.
   Rows sorted by `Last Updated` descending.

2. **`docs/labbooks/<slug>.md`** — one file per study. Structure:
   - Top of file: `Hypothesis:` and `Status:` lines.
   - Below: dated entries appended in **reverse-chronological order** (newest first), each as `## YYYY-MM-DD`.
   - Each entry records three things:
     - **What I did** (actions, code/configs run)
     - **What I observed** (data, numbers, plots, errors)
     - **What I think it means** (interpretation, with an explicit **confidence** level — e.g. low / medium / high)

### When I report progress on a study
- Locate the matching `docs/labbooks/<slug>.md`.
- Prepend a new `## YYYY-MM-DD` entry (do NOT append at the bottom — newest entries go on top, under the hypothesis/status header).
- Update that study's `Last Updated` in `docs/metalabbook.md` and re-sort the table so it stays in `Last Updated` descending order.
- If `Status` should change (e.g. `active` → `done`/`abandoned`), update both the labbook file header and the metalabbook row.

### When the work looks like a NEW study
- Do NOT silently create a new slug or new labbook file. Ask me first: propose a slug, the hypothesis, and confirm before creating `docs/labbooks/<slug>.md` and adding the row to `docs/metalabbook.md`.
