# default-setup — Alacritty + Zellij + pi baseline

Personal terminal + AI-CLI stack baseline for restoring a fresh machine to a known-good state.
Captured 2026-09-20 after fixing the "almost black screen" drift (see [Backstory](#backstory)).

## Stack and versions (as captured)

| Component   | Version    | Live config path                        | Backup copy                       |
|-------------|------------|-----------------------------------------|-----------------------------------|
| Alacritty   | 0.17.0     | `~/.config/alacritty/alacritty.toml`    | `alacritty/alacritty.toml`        |
| Zellij      | 0.45.1     | `~/.config/zellij/config.kdl`           | `zellij/config.kdl`               |
| Theme file  | Kanagawa Wave | `~/.config/alacritty/themes/kanagawa_wave.toml` | `alacritty/themes/kanagawa_wave.toml` |
| Bash        | 5.3.9      | (no customization — stock `~/.bashrc`)  | —                                 |
| pi (AI coding agent) | 0.86.1 — npm global `@earendil-works/pi-coding-agent` under nvm Node v24.16.0 | `~/.pi/agent/` | `pi/`    |
| OS          | Ubuntu 26.04.1 LTS (Wayland) | —                      | —                                 |

Install on Ubuntu: `sudo apt install alacritty zellij` (or grab zellij from its
[official releases](https://github.com/zellij-org/zellij/releases) if apt lags behind).

## Repository layout

```text
default-setup/
├── README.md                        # this file
├── alacritty/
│   ├── alacritty.toml               # main config: imports the theme, launches zellij as the shell
│   └── themes/
│       └── kanagawa_wave.toml       # Kanagawa Wave palette (all 16 + selection + indexed 16/17)
└── zellij/
    └── config.kdl                   # full zellij config: keybinds, options, theme_dark/light
└── pi/
    ├── settings.json                # pi settings: default model, packages, subagent overrides
    ├── mcp.json                     # 10 MCP servers — SANITIZED (placeholders, no real tokens)
    └── extensions/                  # local extensions: herdr-agent-state.ts, tokenjuice.js
```

The backup is **self-sufficient**: no external repo clone is required, because the
imported theme file is included here.

## Restore on a fresh machine (from ground)

Run from inside this folder:

```bash
# 1. Alacritty: main config + theme file
mkdir -p ~/.config/alacritty/themes
cp alacritty/alacritty.toml              ~/.config/alacritty/
cp alacritty/themes/kanagawa_wave.toml   ~/.config/alacritty/themes/

# 2. Zellij
mkdir -p ~/.config/zellij
cp zellij/config.kdl                    ~/.config/zellij/

# 3. Verify
zellij setup --check        # expect: [CONFIG FILE]: Well defined
alacritty --version && zellij --version

# 4. pi coding agent — see the dedicated section below for addons + configs + secrets
```

Then just open Alacritty — it starts `zellij attach -c main` automatically
(`[terminal] shell` setting), landing you in the `main` session.

### Optional: the full alacritty-theme collection

If you want to try other themes, clone the stock collection (174 themes) into the
themes dir — this is where the original `kanagawa_wave.toml` came from:

```bash
git clone --depth 1 https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

**Careful with paths** — see gotcha #1 below. A plain clone puts files at
`~/.config/alacritty/themes/themes/*.toml`, which is NOT what our import expects.

## Refresh this backup (after changing live configs)

```bash
REPO=~/path/to/default-setup   # adjust to wherever you cloned this repo
cp ~/.config/alacritty/alacritty.toml             "$REPO/alacritty/"
cp ~/.config/alacritty/themes/kanagawa_wave.toml  "$REPO/alacritty/themes/"
cp ~/.config/zellij/config.kdl                    "$REPO/zellij/"
cp ~/.pi/agent/settings.json                      "$REPO/pi/"
cp ~/.pi/agent/extensions/*                       "$REPO/pi/extensions/"
# mcp.json — ALWAYS re-sanitize (see the pi section), never cp it raw
cd "$REPO" && git add -A && git commit -m "refresh configs"
```

## How the pieces fit

1. **Alacritty** is the terminal emulator. It owns the **background color, cursor,
   and font** — these come from the imported `kanagawa_wave.toml` plus local overrides
   (the wheat cursor) in `alacritty.toml`.
2. **Alacritty starts Zellij as its shell** (`[terminal] shell = zellij attach -c main`),
   so every Alacritty window lands in the zellij `main` session (created if missing).
3. **Zellij themes only style zellij chrome** — status bar, tab bar, pane frames,
   hints, plugin UI. Pane *content* background is always painted by Alacritty.
   Rule of thumb: *text colors follow zellij, background follows Alacritty*.
4. **Theme switching**: zellij has `theme_dark "kanagawa"` / `theme_light "catppuccin-latte"`.
   Switch manually via `zellij action toggle-theme` (or `set-light-theme` / `set-dark-theme`),
   or the Configuration plugin (`Ctrl o`, then `c`). Alacritty does not report its
   dark/light hue to zellij, so automatic switching never triggers — it's manual only.
   When switching zellij to light, also swap the Alacritty import to
   `catppuccin_latte.toml` (from the themes collection) so the background follows.
5. **Live reload**: Alacritty re-reads its config on save (changes apply instantly to
   open windows). Zellij watches `config.kdl` from 0.45 — `touch` the file or run
   `zellij action ...` from a pane. There is no `ReloadConfig` keybind anymore.

## pi coding agent (AI CLI)

Config root: `~/.pi/agent/` (overridable via `PI_CONFIG_DIR`). Version **0.86.1**, installed
globally via npm (`@earendil-works/pi-coding-agent`) under **nvm Node v24.16.0**.

### What's backed up

| Backup path                | Live path                     | Contents |
|----------------------------|-------------------------------|----------|
| `pi/settings.json`         | `~/.pi/agent/settings.json`   | theme `dark`, default provider/model `zai/glm-5.3` + thinking `high`, enabled `packages` list, subagent model overrides (scout/worker → gpt-5.6-luna, researcher → glm-5.2, oracle → gpt-5.6-terra) |
| `pi/mcp.json`              | `~/.pi/agent/mcp.json`        | 10 MCP servers (context7, cloudflare-docs, pg-aiguide, playwright, web-search-prime, osgrep, drawio, codegraph, zread, fff) — **SANITIZED** |
| `pi/extensions/`           | `~/.pi/agent/extensions/`     | local extensions: `herdr-agent-state.ts`, `tokenjuice.js` (vendored, 250 KB) |

**Deliberately not backed up:** skills (`~/.pi/agent/skills/`, `~/.agents/skills/` —
re-installable stock/reference content), prompt templates (`~/.pi/agent/prompts/` —
personal slash commands, kept as an inventory note below), profiles
(`~/.pi/agent/profiles/` — empty anyway), plus all secrets/state (see below).
Personal prompts inventory for manual recreation: `/init-agents`, `/init-architecture`,
`/init-design`, `/init-custom-skill`, `/commit-changes`, `/hard-plan-execute`,
`copilot-instructions`.

### Addons — reinstall, don't copy

npm addons live in `~/.pi/agent/npm/node_modules` (never backed up). Reinstall with:

```bash
for p in context-mode pi-mcp-adapter @ff-labs/pi-fff @juicesharp/rpiv-ask-user-question \
         @firstpick/pi-extension-git-footer-status pi-subagents @tmustier/pi-usage-extension \
         @juicesharp/rpiv-todo pi-lens; do pi install npm:$p; done
```

Versions as captured in `~/.pi/agent/npm/package.json`: context-mode ^1.0.169,
pi-mcp-adapter ^2.34.0, @ff-labs/pi-fff ^0.10.6, @juicesharp/* ^2.10.1,
@firstpick/pi-extension-git-footer-status ^0.5.4, pi-subagents ^0.70.0,
@tmustier/pi-usage-extension ^0.9.4, pi-lens ^4.2.1.

> **Drift note**: `@zhushanwen/pi-statusline` ^0.6.0 and `pi-token-speed` ^0.7.1 are
> installed in npm but NOT listed in settings.json `packages` (installed-but-disabled).
> Decide deliberately whether to re-enable on restore — the enabled set is the
> `packages` array in settings.json, and both places must stay in sync.

### Secrets policy

- `pi/mcp.json` in this repo is a **sanitized copy**: `Bearer <YOUR_ZAI_API_TOKEN>`
  (web-search-prime, zread) and `<YOUR_CONTEXT7_KEY>` (context7) are placeholders.
- `~/.pi/agent/auth.json` (provider OAuth/API credentials) is deliberately **not**
  backed up — re-authenticate each provider on the new machine (first `pi` run
  triggers the login flow, or use the built-in auth command).
- Stateful/ephemeral stuff is excluded: `sessions/`, `missions/`, `fff/` (frecency+history),
  `token-stats/`, `cache-ratio/`, `mcp-cache.json`, `mcp-npx-cache.json`,
  `models-store.json`, `run-history.jsonl`, `statusline_cache.json`,
  `usage-extension-cache.json`, `trust.json` (per-project trust grants),
  `bin/` (fd/rg — auto-downloaded by pi).

### Restore

```bash
# 1. Node + pi itself
nvm install 24 && nvm alias default 24
npm install -g @earendil-works/pi-coding-agent   # pinned: 0.86.1

# 2. Addons (see loop above)

# 3. Configs
mkdir -p ~/.pi/agent
cp pi/settings.json ~/.pi/agent/
cp pi/extensions/*  ~/.pi/agent/extensions/
cp pi/mcp.json ~/.pi/agent/mcp.json && chmod 600 ~/.pi/agent/mcp.json

# 4. Fill the two token placeholders in ~/.pi/agent/mcp.json, then re-login providers
```

### Refresh (mcp.json must be re-sanitized every time!)

```bash
python3 -c "import re,os; d=open(os.path.expanduser('~/.pi/agent/mcp.json')).read(); \
  d=re.sub(r'Bearer [A-Za-z0-9._-]+','Bearer <YOUR_ZAI_API_TOKEN>',d); \
  d=re.sub(r'(\"CONTEXT7_API_KEY\":\s*\")[^\"]*',r'\1<YOUR_CONTEXT7_KEY>',d); \
  open('pi/mcp.json','w').write(d)"
```

## Zellij cheat sheet (as configured)

| Keys          | Action                                   |
|---------------|------------------------------------------|
| `Ctrl g`      | unlock (sessions start in **locked** mode — `default_mode "locked"`) |
| `Ctrl o`      | session mode                             |
| `Ctrl o` `d`  | detach                                   |
| `Ctrl o` `c`  | Configuration plugin (theme switching UI) |
| `Ctrl p`      | pane mode (navigate/split panes)         |
| `Ctrl n`      | resize mode                              |
| `Ctrl t`      | tab mode                                 |
| `Ctrl s`      | scroll mode                              |
| `Ctrl h`/`Ctrl l` | move focus left/right (in normal mode) |

## Gotchas (learned the hard way — keep these)

1. **Alacritty silently falls back to default colors if the import path is wrong.**
   The original sin: `import = ["~/.config/alacritty/themes/themes/Dracula.toml"]` —
   doubled `themes/` + wrong case. Symptom: near-black screen, "zellij theme does
   nothing to the background". Always verify the import resolves:
   `ls ~/.config/alacritty/themes/kanagawa_wave.toml`.
2. **Main `alacritty.toml` overrides imported theme values.** The `[colors.cursor]`
   wheat override lives in the main file and beats the theme file. Kanagawa Wave
   defines no cursor colors at all — without the override the cursor blends into
   the `#1f1f28` background.
3. **Zellij 0.45 migration notes**: `SwitchToMode "locked"` replaced the old
   `"normal"` mode name; the `theme_dark`/`theme_light` pair (instead of static
   `theme`) enables runtime switching via actions/CLI.
4. **Zellij config backups**: on plugin/version upgrades zellij may regenerate
   `config.kdl` and drop a `config.kdl.bak` next to it — diff against this repo's
   copy to see what drifted (that's how `theme "kanagawa"` + `default_mode "locked"`
   sneaked in during the 0.44.3 → 0.45.1 upgrade).
5. **Bash is stock.** No PS1/pywal/starship anywhere — if colors ever look wrong,
   suspect Alacritty's import path first, bash last.

## Backstory

2026-09-20: after the zellij 0.44.3 → 0.45.1 system-plugin upgrade, the screen went
"almost black". Investigation showed two independent issues stacking up:
the regenerated zellij config added `theme "kanagawa"` + `default_mode "locked"`,
*and* Alacritty's theme import had been broken all along (`themes/themes/Dracula.toml`
— nonexistent path), silently leaving Alacritty on its default black background.
Net result: kanagawa chrome on a dead-black canvas. Fixes applied: import path →
`kanagawa_wave.toml`, wheat cursor override, `theme_dark "kanagawa"` /
`theme_light "catppuccin-latte"`, and this backup repo so the next reinstall is
a `cp` away.
