# Changelog

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
