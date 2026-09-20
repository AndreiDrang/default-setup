# default-setup — Alacritty + Zellij baseline

Personal terminal-stack baseline for restoring a fresh machine to a known-good state.
Captured 2026-09-20 after fixing the "almost black screen" drift (see [Backstory](#backstory)).

## Stack and versions (as captured)

| Component   | Version    | Live config path                        | Backup copy                       |
|-------------|------------|-----------------------------------------|-----------------------------------|
| Alacritty   | 0.17.0     | `~/.config/alacritty/alacritty.toml`    | `alacritty/alacritty.toml`        |
| Zellij      | 0.45.1     | `~/.config/zellij/config.kdl`           | `zellij/config.kdl`               |
| Theme file  | Kanagawa Wave | `~/.config/alacritty/themes/kanagawa_wave.toml` | `alacritty/themes/kanagawa_wave.toml` |
| Bash        | 5.3.9      | (no customization — stock `~/.bashrc`)  | —                                 |
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
cp ~/.config/alacritty/alacritty.toml             ~/Documents/Prog/Private/default-setup/alacritty/
cp ~/.config/alacritty/themes/kanagawa_wave.toml  ~/Documents/Prog/Private/default-setup/alacritty/themes/
cp ~/.config/zellij/config.kdl                    ~/Documents/Prog/Private/default-setup/zellij/
cd ~/Documents/Prog/Private/default-setup && git add -A && git commit -m "refresh configs"
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
