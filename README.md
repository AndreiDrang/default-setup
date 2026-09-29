# default-setup — Alacritty + Zellij + pi + omo baseline

Backup of my personal terminal + AI-CLI stack, captured 2026-09-20.
Self-sufficient: everything needed to restore lives in this repo — copy each
stored config to its destination and you're back at the known-good state.

## Stack and versions

| Component       | Version                      | Notes                                                                |
| --------------- | ---------------------------- | -------------------------------------------------------------------- |
| Alacritty       | 0.17.0                       | terminal emulator                                                    |
| Zellij          | 0.45.1                       | multiplexer; Alacritty starts it as its shell                        |
| Theme           | Kanagawa Wave                | palette file imported by `alacritty.toml`                            |
| Bash            | 5.3.9                        | stock + dynamic pane-title block (OSC 0)                             |
| pi coding agent | 0.87.1                       | npm global `@earendil-works/pi-coding-agent` under nvm Node v24.16.0 |
| omo agent       | 5.1.1 (senpi 2026.9.29)      | pi-family CLI agent; bun global `omo-ai` under `~/.bun`              |
| OS              | Ubuntu 26.04.1 LTS (Wayland) | —                                                                    |

## Stored configs and where they go

Copy each file to its live location (`mkdir -p` the parent dir first):

| Stored in repo                        | Destination                                       |
| ------------------------------------- | ------------------------------------------------- |
| `alacritty/alacritty.toml`            | `~/.config/alacritty/alacritty.toml`              |
| `alacritty/themes/kanagawa_wave.toml` | `~/.config/alacritty/themes/kanagawa_wave.toml`   |
| `zellij/config.kdl`                   | `~/.config/zellij/config.kdl`                     |
| `pi/settings.json`                    | `~/.pi/agent/settings.json`                       |
| `pi/mcp-adapter.json`                 | `~/.pi/agent/mcp-adapter.json` (then `chmod 600`) |
| `pi/extensions/`                      | `~/.pi/agent/extensions/`                         |
| `omo/settings.json`                   | `~/.omo/agent/settings.json`                      |
| `omo/mcp-adapter.json`                | `~/.omo/agent/mcp-adapter.json` (`chmod 600`)     |
| `omo/extensions/`                     | `~/.omo/agent/extensions/`                        |
| `omo/models.json`                     | `~/.omo/agent/models.json` (then `chmod 600`)     |
| `omo/skills/`                         | `~/.omo/agent/skills/` (custom skills only)       |
| `bash/pane-title.sh`                  | append to `~/.bashrc`                             |

What each piece does:

- **`alacritty.toml`** — imports the Kanagawa Wave theme, owns background/cursor/font
  (wheat cursor override), and launches zellij as its shell (`zellij attach -c main`),
  so every terminal window lands in the zellij `main` session.
- **`kanagawa_wave.toml`** — full palette; included so no external theme repo is needed.
- **`config.kdl`** — keybinds, options, `default_mode "locked"`,
  `theme_dark "kanagawa"` / `theme_light "catppuccin-latte"`.
- **`settings.json`** — pi theme, default model `zai/glm-5.3` + thinking `high`,
  enabled packages list, subagent model overrides.
- **`mcp-adapter.json`** — 10 MCP servers (renamed from `mcp.json`: pi-mcp-adapter
  no longer reads `~/.pi/agent/mcp.json`). **Sanitized**: `Bearer <YOUR_ZAI_API_TOKEN>` and
  `<YOUR_CONTEXT7_KEY>` are placeholders — fill them after restore, then re-login
  each provider (`~/.pi/agent/auth.json` is never backed up).
- **`extensions/`** — `herdr-agent-state.ts`, `tokenjuice.js` (vendored).
- **`omo/settings.json`** — omo theme `dark`, default provider
  `chatgpt-subscription` model `gpt-6-luna` + thinking `high`, enabled packages
  list, subagent model overrides (same shape as pi's settings).
- **`omo/mcp-adapter.json`** — 8 MCP servers + `imports: ["claude-code"]`
  (reuses the Claude Code MCP config). **Sanitized** exactly like pi's:
  `Bearer <YOUR_ZAI_API_TOKEN>` and `<YOUR_CONTEXT7_KEY>` are placeholders —
  fill them after restore, then re-login each provider
  (`~/.omo/agent/auth.json` is never backed up).
- **`omo/extensions/`** — `herdr-agent-state.ts`, `tokenjuice.js`, `rtk.ts`,
  `diff.js`, `tps.js`, `files.js`, `prompt-url-widget.js` (vendored).
- **`omo/models.json`** — local provider routing: `openai`, `zai-coding-plan`,
  and `opencode` providers all go through the local sleeve proxy at
  `http://127.0.0.1:17321`; no secrets (localhost URL + routing headers only).
- **`omo/skills/`** — the two custom omo skills (`hard-planner`,
  `hard-planner-research-writer`); the gist-fetched skills are not stored
  (re-fetch, see below).
- **`bash/pane-title.sh`** — dynamic zellij pane titles: while a command runs the pane
  title shows the command, at the prompt it shows `user@host: cwd`. Zellij renders this
  in pane frames and collapsed/stacked pane lines. Precedence: manual rename
  (`Ctrl p` `c` / `zellij action rename-pane`) > this OSC title > command name.
  Install: `grep -q zellij-pane-title ~/.bashrc || cat bash/pane-title.sh >> ~/.bashrc`.

Not backed up (reinstall or regenerate): pi/omo prompts / profiles,
npm addons (reinstall via `pi install npm:<package>`), sessions and state,
all secrets. Pi skills and omo's shared skills are installed from gists —
re-fetch them from <https://gist.github.com/AndreiDrang> (the two custom
omo hard-planner skills are stored in `omo/skills/`). Also never backed up
for omo: `auth.json` (zai / GitHub Copilot / ChatGPT-subscription tokens),
sessions, caches, telemetry (`omo-senpi/`), and vendored `bin/` (`rg`, `fd`).
Verify after restore: `zellij setup --check` and
`alacritty --version && zellij --version && omo --version`.

