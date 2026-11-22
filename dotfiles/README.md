# Dotfiles (Hyprland Lua config + HyDE scripts)

This folder is now the real home of your config. On the Linux machine, GNU Stow
links each file from here into your home folder, so editing
`~/.config/hypr/conf/keybindings.lua` edits this repo, and `git diff` shows it.

| Package | Links into | What's in it |
|---|---|---|
| `hypr/` | `~/.config/hypr/` | `hyprland.lua`, `conf/*.lua`, `themes/common.lua` |
| `hyde/` | `~/.config/hyde/` | the 10 themes' `hypr.theme` and the wallbash `hypr.dcol` |
| `bin/` | `~/.local/share/bin/` | all HyDE scripts |
| `systemd/` | `~/.config/systemd/user/` | `hyde-session.target` and the `hyde-*.service` helpers |

These are **not** linked, because HyDE rewrites them: `~/.config/hypr/themes/theme.lua`,
`~/.config/hypr/themes/colors.lua` and `~/.config/hypr/hyprlock.conf`.
Your old `.conf` files are still in `~/.config/hypr` but nothing reads them.
Keep this repo where you cloned it: the links point into it.

## Applying it (already have the Lua port installed)

```sh
sudo pacman -S stow uwsm      # once
bash tools/update.sh          # backs up, swaps installed files for links, regenerates theme data
# log out, log back in with "Hyprland (uwsm-managed)"
bash tools/verify-binds.sh
```

`update.sh` changes what's installed instead of adding a second copy. It's safe
to run again (the second run changes nothing), and `tools/rollback.sh` puts
everything back the way it was before the first run.

## What changed

**Binds:** the same 127 binds on the same keys. These now run Lua directly
(`conf/actions.lua`, `conf/gamemode.lua`) instead of shell + hyprctl + jq:

- Super+Q and Alt+F4 (close, but only hide Steam)
- Super+Shift+F (pin)
- F6 (touchpad)
- Ctrl+Alt+arrows (rotate the laptop screen)
- Super+Alt+G (gamemode)

F6 now also survives a config reload: before, a reload switched the touchpad
back on.

**Startup:**
- Tray applets, clipboard watchers, the polkit agent, battery notifications,
  kmonad and the Red Dragon watcher are systemd user services, and they restart
  if they crash. Hyprland starts them through `hyde-session.target` and stops them
  when it exits. This works with or without uwsm.
- waybar and dunst are still started by Hyprland, because HyDE's scripts
  restart them themselves.
- `resetxdgportal.sh` (4 seconds of sleeps) is gone.

**Themes are data:** `theme.lua` and `colors.lua` are plain tables, applied by
`conf/theme.lua`.
- A wallpaper change re-applies only the colours (`HYDE.reload_colors()`) instead of reloading the whole config.
- `gsettings` and `setcursor` only run when a value changes.
- A theme switch still does a full reload.

**Performance:**
- Wallpaper hashes are cached (`~/.cache/hyde/wallhash.cache`), so Super+Alt+←/→
  only hashes new or changed images.
- `render.direct_scanout = 2` and `misc.vrr = 2` let fullscreen games and video skip compositing.
- The LG monitor runs at 99.95 Hz.
- Auto gamemode switches effects off while a game is fullscreen, and leaves waybar alone.

**Visual (no blur, no dimming, no opacity changes):**
- Windows move on a spring curve.
- Closing windows fade in ~150 ms.
- Scratchpads slide in vertically and sit inset 48 px.
- The focused window gets a faint inner glow in the wallbash accent colour.

**Cleanup:**
- Window rules are tables in `conf/windowrules.lua` (same rules).
- Hardware names live only in `conf/devices.lua`.

## Notes

- `gamemode.sh` is now only the waybar half (`gamemode.sh on|off`). Run with
  no argument, it toggles gamemode like before.
- The old helper scripts (`dontkillsteam.sh`, `windowpin.sh`,
  `touchpadtoggle.sh`, `resetxdgportal.sh`, `polkitkdeauth.sh`) are kept but
  no longer used by the config.
- To tweak the glow, change `decoration.glow` in `hypr/.config/hypr/themes/common.lua`
  (`enabled = false` turns it off). The scratchpad inset is `gaps_out` in
  `conf/scratchpads.lua`.
- Troubleshooting: if `update.sh` says `colors.lua` wasn't regenerated, change the
  wallpaper once (Super+Alt+→). That rewrites it in the new format.
