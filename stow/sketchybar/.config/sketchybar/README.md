# Glass-pill SketchyBar

Adapted from [wthrajat's setup](https://github.com/FelixKratz/SketchyBar/discussions/47#discussioncomment-18312734)
and [configuration](https://github.com/wthrajat/dotfiles-mac/tree/main/sketchybar).
Uses the existing Hack Nerd Font Mono and AeroSpace installation.

- Numbered workspaces remain visible; named workspaces appear when occupied or focused.
- The gold chip marks the focused workspace. Click a workspace to focus it.
- The music pill shows system Now Playing and previous/play/pause/next controls.
  Controls do nothing when no player is active.
- Right-side pills show CPU die temperature, memory used, CPU usage, date, time, and battery.

All configuration and helper binaries live in this folder. No launch agents,
window-manager settings, wallpaper, or system fonts are installed or changed.
SketchyBar starts one media helper; reloads reuse it. Runtime logs are in
`/tmp/sketchybar-glass-media.log`.

## Helpers

- [sketchybar-now-playing v0.4.3](https://github.com/wthrajat/sketchybar-now-playing/releases/tag/v0.4.3),
  arm64 release archive SHA-256:
  `3a97570734b4423609a722b7886dd0a39ba71b025b5fb5c79e081e1d2cb161e0`.
  The binary lives at `helpers/sketchybar-now-playing`; its MIT license is alongside it.
- [mac-temp](https://github.com/zackwag/mac-temp), compiled locally from the source
  in `helpers/mac-temp.m`. Build from this directory with:
  `clang -fobjc-arc -framework Foundation -framework IOKit -o helpers/mac-temp helpers/mac-temp.m`.
  Its MIT license is alongside the source.

Helper binaries and backups are ignored by Git. If moving this config to another
machine, build mac-temp and download the matching architecture's music helper
into `helpers/` before reloading.

## Restore the previous setup

The original configuration is saved in `.backups/before-glass-theme-*.tar.gz`.
From this folder, extract the chosen archive with `tar -xzf .backups/<archive>`
and run `sketchybar --reload`. To stop the optional music helper as well, find its
PID with `pgrep -f '[s]ketchybar-now-playing daemon'` and send that PID `SIGTERM`.
