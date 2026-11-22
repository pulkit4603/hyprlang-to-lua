-- █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
-- █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█
--
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
--  &  https://wiki.hypr.land/Configuring/Basics/Dispatchers/
--
-- Same keys, same order, duplicates kept. A few binds now call a Lua function
-- (conf/actions.lua, conf/gamemode.lua) instead of a hyprctl script; they do
-- the same thing. Old flag letters → Lua options:
--   bindl  → { locked = true }
--   binde  → { repeating = true }
--   bindel → { locked = true, repeating = true }
--   bindm  → { mouse = true } with hl.dsp.window.drag() / resize()
-- Modifier names must be UPPERCASE in Lua ("SUPER + SHIFT + X").

local hyde = require("conf.hyde")
local actions = require("conf.actions")
local gamemode = require("conf.gamemode")
local scr = hyde.scr
local dsp = hl.dsp

-- Main modifier
local mainMod = "SUPER" -- super / meta / windows key

-- small helper: mainMod .. " + X"
local function M(rest)
    return mainMod .. " + " .. rest
end

local function exec(cmd)
    return dsp.exec_cmd(cmd)
end

-- Assign apps
local term = "kitty"
local editor = "code"
local file = "dolphin"
local browser = "firefox" -- replace with firefox if needed
local musicplayer = "spotify"
local discord = "vesktop"
local notetaker = "obsidian"

-- Window/Session actions
-- hl.bind(M("SHIFT + K"), exec("killall kmonad || kmonad $HOME/.config/kmonad/conf.kbd"))
hl.bind("F12", exec("pgrep -x tty-clock > /dev/null || kitten panel --edge=background -o background_opacity=0.1 tty-clock -C 5 -csS"), { description = "start showing a clock in the background" })
hl.bind("F11", exec("killall tty-clock"), { description = "kill the aforementioned clock if it is running" })
hl.bind(M("Q"), actions.close_active, { description = "close focused window" }) -- was dontkillsteam.sh
hl.bind("ALT + F4", actions.close_active, { description = "close focused window" }) -- was dontkillsteam.sh
hl.bind(M("Delete"), dsp.exit(), { description = "kill hyprland session" })
hl.bind(M("W"), dsp.window.float({ action = "toggle" }), { description = "toggle the window between focus and float" })
hl.bind(M("G"), dsp.group.toggle(), { description = "toggle the window between focus and group" })
hl.bind("ALT + Return", dsp.window.fullscreen(), { description = "toggle the window between focus and fullscreen" })
hl.bind(M("L"), exec("hyprlock"), { description = "launch lock screen" })
hl.bind(M("SHIFT + F"), actions.toggle_pin, { description = "toggle pin on focused window" }) -- was windowpin.sh
hl.bind(M("Backspace"), exec(scr("logoutlaunch.sh")), { description = "launch logout menu" })
hl.bind("CTRL + ALT + W", exec("killall waybar || waybar"), { description = "toggle waybar" })
hl.bind(M("Equal"), exec("kmonad ~/.config/kmonad/reddragon_conf.kbd"))

-- Application shortcuts
hl.bind(M("T"), exec(term), { description = "launch terminal emulator" })
hl.bind(M("E"), exec(file), { description = "launch file manager" })
hl.bind(M("C"), exec(editor), { description = "launch text editor" })
hl.bind(M("F"), exec(browser), { description = "launch web browser" })
hl.bind(M("S"), exec(musicplayer), { description = "launch music player" })
hl.bind(M("D"), exec(discord), { description = "launch discord" })
hl.bind(M("N"), exec(notetaker), { description = "launch note taking application" })
hl.bind("CTRL + SHIFT + Escape", exec(scr("sysmonlaunch.sh")), { description = "launch system monitor (htop/btop or fallback to top)" })
hl.bind(M("Y"), exec("kitty --directory ~ yazi"), { description = "Yazi TUI File Browser" })
hl.bind(M("B"), exec("calibre"), { description = "Virtual Library" })

-- Rofi menus
hl.bind(M("A"), exec("pkill -x rofi || " .. scr("rofilaunch.sh") .. " d"), { description = "launch application launcher" })
hl.bind(M("Tab"), exec("pkill -x rofi || " .. scr("rofilaunch.sh") .. " w"), { description = "launch window switcher" })
hl.bind(M("SHIFT + E"), exec("pkill -x rofi || " .. scr("rofilaunch.sh") .. " f"), { description = "launch file explorer" })

-- Audio control
hl.bind("F1", exec(scr("volumecontrol.sh") .. " -o m"), { locked = true, description = "toggle audio mute" })
hl.bind("F2", exec(scr("volumecontrol.sh") .. " -o d"), { locked = true, repeating = true, description = "decrease volume" })
hl.bind("F3", exec(scr("volumecontrol.sh") .. " -o i"), { locked = true, repeating = true, description = "increase volume" })
hl.bind("XF86AudioMute", exec(scr("volumecontrol.sh") .. " -o m"), { locked = true, description = "toggle audio mute" })
hl.bind("XF86AudioMicMute", exec(scr("volumecontrol.sh") .. " -i m"), { locked = true, description = "toggle microphone mute" })
hl.bind("XF86AudioLowerVolume", exec(scr("volumecontrol.sh") .. " -o d"), { locked = true, repeating = true, description = "decrease volume" })
hl.bind("XF86AudioRaiseVolume", exec(scr("volumecontrol.sh") .. " -o i"), { locked = true, repeating = true, description = "increase volume" })

-- Media control
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true, description = "toggle between media play and pause" })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true, description = "toggle between media play and pause" })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true, description = "media next" })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true, description = "media previous" })

-- Brightness control
hl.bind("XF86MonBrightnessUp", exec(scr("brightnesscontrol.sh") .. " i"), { locked = true, repeating = true, description = "increase brightness" })
hl.bind("XF86MonBrightnessDown", exec(scr("brightnesscontrol.sh") .. " d"), { locked = true, repeating = true, description = "decrease brightness" })

-- Move between grouped windows
hl.bind(M("CTRL + H"), dsp.group.prev()) -- was: changegroupactive, b
hl.bind(M("CTRL + L"), dsp.group.next()) -- was: changegroupactive, f

-- (GITHUB TO PUSH)
-- Monitor Keybindings (rotate the laptop panel; Up/Down apply the rule twice, as before)
hl.bind("CTRL + ALT + Up", actions.rotate(0, 2), { description = "upright" })
hl.bind("CTRL + ALT + Down", actions.rotate(2, 2), { description = "topsy turvy" })
hl.bind("CTRL + ALT + Right", actions.rotate(3), { description = "Rotated right" })
hl.bind("CTRL + ALT + Left", actions.rotate(1), { description = "Rotated left" })
-- (GITHUB TO PUSH)

-- Screenshot/Screencapture
hl.bind(M("P"), exec(scr("screenshot.sh") .. " s"), { description = "partial screenshot capture" })
hl.bind(M("CTRL + P"), exec(scr("screenshot.sh") .. " sf"), { description = "partial screenshot capture (frozen screen)" })
hl.bind(M("ALT + P"), exec(scr("screenshot.sh") .. " m"), { description = "monitor screenshot capture" })
hl.bind("Print", exec(scr("screenshot.sh") .. " p"), { description = "all monitors screenshot capture" })

-- Custom scripts
hl.bind(M("ALT + G"), gamemode.toggle, { description = "disable hypr effects for gamemode" })
hl.bind(M("ALT + Right"), exec(scr("swwwallpaper.sh") .. " -n"), { description = "next wallpaper" })
hl.bind(M("ALT + Left"), exec(scr("swwwallpaper.sh") .. " -p"), { description = "previous wallpaper" })
hl.bind(M("ALT + Up"), exec(scr("wbarconfgen.sh") .. " n"), { description = "next waybar mode" })
hl.bind(M("ALT + Down"), exec(scr("wbarconfgen.sh") .. " p"), { description = "previous waybar mode" })
hl.bind(M("SHIFT + R"), exec("pkill -x rofi || " .. scr("wallbashtoggle.sh") .. " -m"), { description = "launch wallbash mode select menu" })
hl.bind(M("SHIFT + T"), exec("pkill -x rofi || " .. scr("themeselect.sh")), { description = "launch theme select menu" })
hl.bind(M("SHIFT + A"), exec("pkill -x rofi || " .. scr("rofiselect.sh")), { description = "launch select menu" })
hl.bind(M("SHIFT + W"), exec("pkill -x rofi || " .. scr("swwwallselect.sh")), { description = "launch wallpaper select menu" })
hl.bind(M("V"), exec("pkill -x rofi || " .. scr("cliphist.sh") .. " c"), { description = "launch clipboard" })
hl.bind(M("K"), exec(scr("keyboardswitch.sh")), { description = "switch keyboard layout" })

-- Move/Change window focus
hl.bind(M("Left"), dsp.focus({ direction = "l" }))
hl.bind(M("Right"), dsp.focus({ direction = "r" }))
hl.bind(M("Up"), dsp.focus({ direction = "u" }))
hl.bind(M("Down"), dsp.focus({ direction = "d" }))
hl.bind("ALT + Tab", dsp.focus({ direction = "d" }))

-- Switch workspaces
for i = 1, 10 do
    local key = tostring(i % 10) -- 10 maps to key 0
    hl.bind(M(key), dsp.focus({ workspace = tostring(i) }))
end

-- Switch workspaces to a relative workspace
hl.bind(M("CTRL + Right"), dsp.focus({ workspace = "e+1" }))
hl.bind(M("CTRL + Left"), dsp.focus({ workspace = "e-1" }))

-- Move to the first empty workspace
hl.bind(M("CTRL + Down"), dsp.focus({ workspace = "empty" }))

-- Resize windows
hl.bind(M("SHIFT + Right"), dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(M("SHIFT + Left"), dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(M("SHIFT + Up"), dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(M("SHIFT + Down"), dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Move focused window to a workspace
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(M("SHIFT + " .. key), dsp.window.move({ workspace = tostring(i) }))
end

-- Move focused window to a relative workspace
hl.bind(M("CTRL + ALT + Right"), dsp.window.move({ workspace = "r+1" }))
hl.bind(M("CTRL + ALT + Left"), dsp.window.move({ workspace = "r-1" }))

-- Move focused window around the current workspace
hl.bind(M("SHIFT + CTRL + Left"), dsp.window.move({ direction = "l" }))
hl.bind(M("SHIFT + CTRL + Right"), dsp.window.move({ direction = "r" }))
hl.bind(M("SHIFT + CTRL + Up"), dsp.window.move({ direction = "u" }))
hl.bind(M("SHIFT + CTRL + Down"), dsp.window.move({ direction = "d" }))

-- Scroll through existing workspaces
hl.bind(M("mouse_down"), dsp.focus({ workspace = "e+1" }))
hl.bind(M("mouse_up"), dsp.focus({ workspace = "e-1" }))

-- Move/Resize focused window
hl.bind(M("mouse:272"), dsp.window.drag(), { mouse = true })
hl.bind(M("mouse:273"), dsp.window.resize(), { mouse = true })
hl.bind(M("Z"), dsp.window.drag(), { mouse = true })
hl.bind(M("X"), dsp.window.resize(), { mouse = true })

-- Move/Switch to special workspaces (scratchpad)
hl.bind(M("ALT + S"), dsp.workspace.toggle_special("spotifyWin"))
hl.bind(M("ALT + D"), dsp.workspace.toggle_special("dekhoWin"))
hl.bind(M("ALT + K"), dsp.workspace.toggle_special("kaamWin"))
hl.bind(M("ALT + N"), dsp.workspace.toggle_special("notetakerWin"))
hl.bind(M("ALT + C"), dsp.workspace.toggle_special("chatgptWin"))
hl.bind(M("ALT + R"), dsp.workspace.toggle_special("chatgptWin"))

hl.bind(M("SHIFT + S"), dsp.window.move({ workspace = "special:spotifyWin", follow = false }))
hl.bind(M("SHIFT + D"), dsp.window.move({ workspace = "special:dekhoWin", follow = false }))
hl.bind(M("SHIFT + K"), dsp.window.move({ workspace = "special:kaamWin", follow = false }))
hl.bind(M("SHIFT + N"), dsp.window.move({ workspace = "special:notetakerWin", follow = false }))
hl.bind(M("SHIFT + C"), dsp.window.move({ workspace = "special:chatgptWin", follow = false }))

-- Toggle special workspaces (pypr scratchpad)
-- hl.bind(M("ALT + S"), exec("pypr toggle music"))
-- hl.bind(M("ALT + F"), exec("pypr toggle browser"))
-- hl.bind(M("ALT + T"), exec("pypr toggle term"))
-- hl.bind(M("ALT + N"), exec("pypr toggle notes"))

-- Toggle focused window split
hl.bind(M("J"), dsp.layout("togglesplit"))

-- Move focused window to a workspace silently
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(M("ALT + " .. key), dsp.window.move({ workspace = tostring(i), follow = false }))
end
