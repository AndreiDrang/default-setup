# AGENTS.md — instructions for coding agents working on this repo

This repo is a backup of the personal terminal + AI-CLI stack
(Alacritty + Zellij + pi coding agent + omo agent). Follow these rules when asked to
update, refresh, or extend it.

## Restoring (context — don't do this on request here)

- Install the stack: `sudo apt install alacritty zellij` (or zellij from its
  [official releases](https://github.com/zellij-org/zellij/releases)); pi via npm
  (`@earendil-works/pi-coding-agent`); omo via bun (`bun add -g omo-ai`).
- Copy each stored config to its live location per the table in `README.md`,
  fill in the sanitized tokens in `pi/mcp-adapter.json` and
  `omo/mcp-adapter.json`, and re-login each MCP provider in both agents.

## Upgrading / refreshing the repo data

When live configs have changed and the backup must catch up:

1. `cp` the live configs over the repo copies:
   - `~/.config/alacritty/alacritty.toml` → `alacritty/alacritty.toml`
   - `~/.config/alacritty/themes/kanagawa_wave.toml` → `alacritty/themes/kanagawa_wave.toml`
   - `~/.config/zellij/config.kdl` → `zellij/config.kdl`
   - `~/.pi/agent/settings.json` → `pi/settings.json`
   - `~/.pi/agent/extensions/` → `pi/extensions/`
   - `~/.pi/agent/skills/` → `pi/skills/`
   - `~/.omo/agent/settings.json` → `omo/settings.json`
   - `~/.omo/agent/extensions/` → `omo/extensions/`
   - `~/.omo/agent/models.json` → `omo/models.json`
   - `~/.omo/agent/skills/hard-planner*/` → `omo/skills/` (custom skills
     only; the rest of `~/.omo/agent/skills/` is gist-fetched and not backed up)
2. `pi/mcp-adapter.json` (live: `~/.pi/agent/mcp-adapter.json`) and
   `omo/mcp-adapter.json` (live: `~/.omo/agent/mcp-adapter.json`): **never** `cp`
   the raw live files. Diff them manually and re-sanitize secrets — tokens must
   appear only as `Bearer <YOUR_ZAI_API_TOKEN>` and `<YOUR_CONTEXT7_KEY>`
   placeholders. Re-check `omo/models.json` for auth headers/secrets on every
   refresh (currently clean — localhost sleeve proxy routing only).
3. If a component version changed, update the version table in `README.md`.
4. Never commit secrets, `auth.json`, sessions, or other state files.
5. Verify after any restore/refresh: `zellij setup --check` and
   `alacritty --version && zellij --version && omo --version`.

## Mandatory: fill the change log (config changes only)

Record an entry in `log.md` **only when the stored config data changes** —
anything under `alacritty/`, `zellij/`, `pi/`, or `omo/` (including version bumps
that also touch the version table in `README.md`).

Do **not** log changes to `README.md` prose, `AGENTS.md`, `log.md` itself,
or any other non-config files — those need no changelog entry.

- Entry format: a `## YYYY-MM-DD` heading followed by a bullet list of what
  changed and why.
- Newest entries go at the top, right under the `# Changelog` title.
- If today's date already has an entry, append bullets to it instead of
  creating a duplicate heading.
