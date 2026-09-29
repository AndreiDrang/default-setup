# Changelog

## 2026-09-29

- Added new `omo/` module — backup of the omo agent config (omo `5.1.1`,
  engine senpi 2026.9.29), mirroring the `pi/` module layout:
  - `omo/settings.json` — theme `dark`, default provider
    `chatgpt-subscription` / model `gpt-6-luna` + thinking `high`, packages
    list, subagent model overrides.
  - `omo/mcp-adapter.json` — sanitized from live `~/.omo/agent/mcp-adapter.json`:
    8 MCP servers + `claude-code` import; real tokens replaced with
    `Bearer <YOUR_ZAI_API_TOKEN>` / `<YOUR_CONTEXT7_KEY>` placeholders.
  - `omo/extensions/` — 7 vendored extensions: `herdr-agent-state.ts`,
    `tokenjuice.js`, `rtk.ts`, `diff.js`, `tps.js`, `files.js`,
    `prompt-url-widget.js` (verified byte-identical to live).
  - Deliberately excluded: `auth.json` (zai / Copilot / ChatGPT tokens),
    sessions, caches, telemetry (`omo-senpi/`), vendored `bin/rg`+`fd`,
    skills/prompts (gist-fetched like pi's).
- `README.md`: version table, stored-configs table, and module notes extended
  with the omo rows (part of the module addition).
- `omo/` refresh (same day, live omo gained new files; binary still `5.1.1`):
  - Added `omo/models.json` — new local provider-routing config: `openai`,
    `zai-coding-plan`, `opencode` all via the sleeve proxy at
    `http://127.0.0.1:17321`; no secrets.
  - Added `omo/skills/` — two new custom skills from
    `~/.omo/agent/skills/`: `hard-planner`, `hard-planner-research-writer`
    (gist-fetched skills stay excluded).
  - `omo/settings.json`, `omo/mcp-adapter.json`, `omo/extensions/`: verified
    byte-identical to live — unchanged.
- `README.md` / `AGENTS.md`: stored-configs table, bullets, and refresh
  instructions extended for `omo/models.json` + `omo/skills/`.
- `omo/settings.json`: synced from live — added per-model thinking prefs:
  `modelThinkingLevels` and `modelLastOnThinkingLevels` set
  `chatgpt-subscription/gpt-6-luna-fast` → `low` (+ `model-command-search`
  tips-history entry). Everything else verified unchanged
  (`mcp-adapter.json`, `models.json`, `extensions/`, both custom skills);
  omo still `5.1.1`.
- `omo/settings.json`: synced again — `tipsHistory` gained two more entries
  (`model-cycling-scope`, `thinking-budgets`); no functional config change.
  All other module files re-verified unchanged; omo still `5.1.1`.

## 2026-09-27

- `pi/mcp-adapter.json`: renamed from `pi/mcp.json` — pi-mcp-adapter no longer
  reads `~/.pi/agent/mcp.json`; the live file moved to
  `~/.pi/agent/mcp-adapter.json`. Content unchanged: verified identical to the
  previous repo copy after masking tokens; sanitization placeholders preserved.
- `README.md` version table: pi coding agent `0.86.1` → `0.87.1` (missed in
  the 2026-09-25 refresh).

## 2026-09-25

- `pi/settings.json`: synced from live `~/.pi/agent/settings.json` — updated
  subagent model overrides: `scout` and `worker` → `openai-codex/gpt-6-luna`,
  `researcher` → `zai/glm-5.3`, `oracle` → `openai-codex/gpt-6-sol`
  (was `gpt-5.6-luna` / `glm-5.2` / `gpt-5.6-terra`).
- `pi/settings.json`: `lastChangelogVersion` bumped `0.86.1` → `0.87.1`.

## 2026-09-21

- `zellij/config.kdl`: added `pane_frame_style "full"` to restore the pre-0.45
  full-border pane frames instead of the new default single title line.
- `zellij/config.kdl`: added `stacked_pane_list false` to restore the pre-0.45
  stacked-pane rendering (expanded pane in place, stacked panes look like normal
  collapsed panes) instead of the one-line title list.
- Removed the "Install" note and the "Refreshing the backup" section from
  `README.md` (moved into `AGENTS.md`).
- Added `AGENTS.md`: instructions for agents on refreshing/upgrading the repo
  data (config copy map, `mcp.json` sanitization, version-table upkeep) and the
  mandatory change-log task.
- Added `log.md` (this file) as the repo change log.
