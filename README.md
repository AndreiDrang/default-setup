# default-setup — Alacritty + Zellij + pi baseline

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
| pi coding agent | 0.86.1                       | npm global `@earendil-works/pi-coding-agent` under nvm Node v24.16.0 |
| OS              | Ubuntu 26.04.1 LTS (Wayland) | —                                                                    |

## Stored configs and where they go

Copy each file to its live location (`mkdir -p` the parent dir first):

| Stored in repo                        | Destination                                     |
| ------------------------------------- | ----------------------------------------------- |
| `alacritty/alacritty.toml`            | `~/.config/alacritty/alacritty.toml`            |
| `alacritty/themes/kanagawa_wave.toml` | `~/.config/alacritty/themes/kanagawa_wave.toml` |
| `zellij/config.kdl`                   | `~/.config/zellij/config.kdl`                   |
| `pi/settings.json`                    | `~/.pi/agent/settings.json`                     |
| `pi/mcp.json`                         | `~/.pi/agent/mcp.json` (then `chmod 600`)       |
| `pi/extensions/`                      | `~/.pi/agent/extensions/`                       |
| `bash/pane-title.sh`                 | append to `~/.bashrc`                            |

What each piece does:

- **`alacritty.toml`** — imports the Kanagawa Wave theme, owns background/cursor/font
  (wheat cursor override), and launches zellij as its shell (`zellij attach -c main`),
  so every terminal window lands in the zellij `main` session.
- **`kanagawa_wave.toml`** — full palette; included so no external theme repo is needed.
- **`config.kdl`** — keybinds, options, `default_mode "locked"`,
  `theme_dark "kanagawa"` / `theme_light "catppuccin-latte"`.
- **`settings.json`** — pi theme, default model `zai/glm-5.3` + thinking `high`,
  enabled packages list, subagent model overrides.
- **`mcp.json`** — 10 MCP servers. **Sanitized**: `Bearer <YOUR_ZAI_API_TOKEN>` and
  `<YOUR_CONTEXT7_KEY>` are placeholders — fill them after restore, then re-login
  each provider (`~/.pi/agent/auth.json` is never backed up).
- **`extensions/`** — `herdr-agent-state.ts`, `tokenjuice.js` (vendored).
- **`bash/pane-title.sh`** — dynamic zellij pane titles: while a command runs the pane
  title shows the command, at the prompt it shows `user@host: cwd`. Zellij renders this
  in pane frames and collapsed/stacked pane lines. Precedence: manual rename
  (`Ctrl p` `c` / `zellij action rename-pane`) > this OSC title > command name.
  Install: `grep -q zellij-pane-title ~/.bashrc || cat bash/pane-title.sh >> ~/.bashrc`.

Not backed up (reinstall or regenerate): pi skills / prompts / profiles, npm addons
(reinstall via `pi install npm:<package>`), sessions and state, all secrets.
Pi skills are installed from gists — re-fetch them from
<https://gist.github.com/AndreiDrang>.
Verify after restore: `zellij setup --check` and `alacritty --version && zellij --version`.

