-- █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
-- █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█
--
-- Long-running helpers (tray applets, clipboard watchers, polkit agent,
-- battery notifier, kmonad, the Red Dragon watcher) are systemd user services
-- now (~/.config/systemd/user/hyde-*.service). They restart themselves if they
-- crash. Hyprland starts them all through hyde-session.target and stops them
-- when it exits.
--
-- waybar and dunst stay here on purpose: HyDE's scripts kill and restart them
-- directly (gamemode.sh, wbarconfgen.sh, wallbashdunst.sh), which would fight
-- with systemd.
--
-- The old resetxdgportal.sh (4 seconds of sleeps + killing the portals) is
-- gone: once the environment is exported to systemd below, the portals start
-- normally through D-Bus.

local hyde = require("conf.hyde")
local scr = hyde.scr

hl.on("hyprland.start", function()
    -- Give systemd/D-Bus this session's environment (WAYLAND_DISPLAY, PATH, ...)
    -- and only then start the services, so they get the right environment.
    hl.exec_cmd("dbus-update-activation-environment --systemd --all && systemctl --user start hyde-session.target")

    hl.exec_cmd("waybar") -- launch the system bar
    hl.exec_cmd("dunst") -- start notification demon
    hl.exec_cmd(scr("swwwallpaper.sh")) -- start wallpaper daemon and set the wallpaper
end)

hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop hyde-session.target")
end)
