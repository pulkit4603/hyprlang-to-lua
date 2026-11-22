-- Gamemode: turns off animations, shadows, blur, glow, gaps and rounding.
--
-- Manual (Super+Alt+G): same as the old gamemode.sh, including pausing
-- waybar's CSS animations (gamemode.sh still does that part). Pressing it again
-- restores everything with a config reload, as before.
--
-- Automatic: when a game goes fullscreen, the Hyprland part switches on by
-- itself (waybar is left alone, so it doesn't flicker), and switches off
-- again once no fullscreen game is left. Manual gamemode always wins.

local hyde = require("conf.hyde")

local G = {}

-- module state lives in the Lua VM; a config reload resets it, which is
-- exactly how gamemode is switched off anyway
local mode = nil -- nil | "manual" | "auto"

local FULLSCREEN = 2 -- bit set in window.fullscreen when the window is fullscreen (not just maximised)

local EFFECTS_OFF = {
    animations = { enabled = false },
    decoration = {
        shadow = { enabled = false },
        blur = { enabled = false },
        glow = { enabled = false },
        rounding = 0,
    },
    general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
}

local function effects_off()
    hl.config(EFFECTS_OFF)
end

local function restore()
    -- a reload re-applies the whole config (and resets `mode` to nil)
    hl.exec_cmd("hyprctl reload")
end

local function animations_on()
    local v = hl.get_config("animations.enabled")
    return v == true or v == 1
end

-- Super+Alt+G
function G.toggle()
    if animations_on() then
        mode = "manual"
        effects_off()
        hl.exec_cmd(hyde.scr("gamemode.sh") .. " on") -- waybar part
    else
        local was_manual = (mode ~= "auto")
        mode = nil
        if was_manual then
            hl.exec_cmd(hyde.scr("gamemode.sh") .. " off")
        end
        restore()
    end
end

-- what counts as a game: windows that say so, Steam games, gamescope
local function is_game(w)
    if not w then
        return false
    end
    local class = w.class or ""
    return w.content_type == "game" or class:match("^steam_app_%d+$") ~= nil or class == "gamescope"
end

local function is_fullscreen(w)
    return ((w.fullscreen or 0) & FULLSCREEN) ~= 0
end

local function fullscreen_game_running(ignore)
    for _, w in ipairs(hl.get_windows()) do
        if w.address ~= ignore and is_fullscreen(w) and is_game(w) then
            return true
        end
    end
    return false
end

local function reevaluate(ignore_address)
    if mode == "manual" then
        return
    end
    local want = fullscreen_game_running(ignore_address)
    if want and mode == nil then
        mode = "auto"
        effects_off()
    elseif not want and mode == "auto" then
        mode = nil
        restore()
    end
end

function G.setup_auto()
    hl.on("window.fullscreen", function()
        reevaluate(nil)
    end)
    -- the closing window may still be listed, so ignore it explicitly
    hl.on("window.close", function(w)
        reevaluate(w and w.address or nil)
    end)
end

-- exposed for testing
G._is_game = is_game
G._state = function()
    return mode
end

return G
