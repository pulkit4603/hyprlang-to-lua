--
--      ░▒▒▒░░░░░▓▓          ___________
--    ░░▒▒▒░░░░░▓▓        //___________/
--   ░░▒▒▒░░░░░▓▓     _   _ _    _ _____
--   ░░▒▒░░░░░▓▓▓▓▓▓ | | | | |  | |  __/
--    ░▒▒░░░░▓▓   ▓▓ | |_| | |_/ /| |___
--     ░▒▒░░▓▓   ▓▓   \__  |____/ |____/
--       ░▒▓▓   ▓▓  //____/
--
-- Lua port of Pulkit's HyDE-based hyprland.conf (written for Hyprland 0.56).
-- Hyprland loads this file instead of hyprland.conf whenever both exist.
--
-- Load order is the same as the old `source =` order, so later files still
-- override earlier ones (userprefs.lua last).

local hyde = require("conf.hyde") -- shared helpers (scrPath, gsettings queue)
hyde.reset()

require("conf.monitors")
require("conf.autostart")
require("conf.env")
require("conf.input")
require("conf.general")

require("conf.animations")
require("conf.keybindings")
require("conf.windowrules")
require("themes.common") -- shared theme settings
pcall(require, "themes.theme") -- theme specific settings (written by themeswitch.sh)
pcall(require, "themes.colors") -- wallbash colour override (written by swwwallbash.sh)
require("conf.userprefs")

-- Runs every queued `gsettings set ...` one after another, in a single shell.
-- (In hyprlang these were separate `exec =` lines that raced each other, so
-- the GTK theme could randomly end up as the theme's or as Wallbash-Gtk.)
hyde.flush_gsettings()
