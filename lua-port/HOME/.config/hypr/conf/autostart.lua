-- █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
-- █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█
--
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- These were `exec-once =` lines. In Lua, anything written at the top level of
-- the config runs again on every reload, so start-once programs must go inside
-- the "hyprland.start" event, which fires only once per session.

local hyde = require("conf.hyde")
local scr = hyde.scr

hl.on("hyprland.start", function()
    hl.exec_cmd(scr("resetxdgportal.sh")) -- reset XDPH for screenshare
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd("dbus-update-activation-environment --systemd --all") -- for XDPH
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- for XDPH
    hl.exec_cmd(scr("polkitkdeauth.sh")) -- authentication dialogue for GUI apps
    hl.exec_cmd("waybar") -- launch the system bar
    hl.exec_cmd("blueman-applet") -- systray app for Bluetooth
    hl.exec_cmd("udiskie --no-automount --smart-tray") -- front-end that allows to manage removable media
    hl.exec_cmd("nm-applet --indicator") -- systray app for Network/Wifi
    hl.exec_cmd("dunst") -- start notification demon
    hl.exec_cmd("wl-paste --type text --watch cliphist store") -- clipboard store text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- clipboard store image data
    hl.exec_cmd(scr("swwwallpaper.sh")) -- start wallpaper daemon
    hl.exec_cmd(scr("batterynotify.sh")) -- battery notification
    hl.exec_cmd("kmonad $HOME/.config/kmonad/conf.kbd")
    hl.exec_cmd("~/.local/bin/watch-reddragon.sh")
    -- hl.exec_cmd("kmonad $HOME/.config/kmonad/reddragon_conf.kbd")
    -- hl.exec_cmd("kitten panel --edge=background -o background_opacity=0.1 tty-clock -C 5 -csS")
end)
