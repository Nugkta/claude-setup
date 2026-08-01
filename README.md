# claude-setup

Personal Claude Code configuration, kept here so it can be restored on any machine.

## What's in here

- `skills/deep-planning/` — user-level skill (`~/.claude/skills/deep-planning/`)
- `claude/settings.json` — template of `~/.claude/settings.json` (plugin list, model, permissions, UI prefs)
- `CLAUDE-mac.md` — project `CLAUDE.md` template used on the Mac (documentation standards, lab notebook protocol, general working rules)

## What's deliberately NOT in here

- `.credentials.json`, OAuth tokens, MCP secrets — never commit these
- `history.jsonl`, `session-env/`, `tasks/`, `projects/*/memory/` — per-machine session state and auto-memory, not portable
- The `herdr-agent-state.sh` hook — installed/managed by the third-party `herdr` integration; reinstall it on the new machine via herdr itself instead of copying the file
- Plugin source code (e.g. `superpowers`, `code-simplifier`) — these live in their own repos and are installed via Claude Code's plugin marketplace system, not copied here

## Restoring on a new machine

### 1. Skills

```bash
mkdir -p ~/.claude/skills
cp -r skills/deep-planning ~/.claude/skills/
```

### 2. Settings

Copy `claude/settings.json` to `~/.claude/settings.json` (or merge it into an existing one), then fix the two machine-specific placeholders inside it:

- `env.TMPDIR` — point at a tmp dir on the new machine, or delete the key
- `statusLine.command` — replace the `<ADJUST: path to your bun binary>` placeholder with the output of `which bun` on the new machine (only needed if you use the `claude-hud` statusline)

### 3. Plugins

`enabledPlugins` and `extraKnownMarketplaces` in `settings.json` are usually enough for Claude Code to auto-discover and offer to install everything on next launch. If it doesn't, add marketplaces and install plugins manually:

```
/plugin marketplace add anthropics/claude-plugins-official   # superpowers, code-simplifier, discord, frontend-design
/plugin marketplace add obra/superpowers-marketplace         # superpowers' own marketplace
/plugin marketplace add jarrodwatts/claude-hud
/plugin marketplace add openai/codex-plugin-cc
/plugin marketplace add Nugkta/paper-writer

/plugin install superpowers@claude-plugins-official
/plugin install code-simplifier@claude-plugins-official
/plugin install discord@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install claude-hud@claude-hud
/plugin install codex@openai-codex
/plugin install paper-writer@paper-writer
```

## Updating this repo

When you change something in `~/.claude/` that's worth keeping, copy it back into this repo and commit — there's no automatic sync.
