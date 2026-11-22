-- Theme engine.
--
-- The look comes from three plain data files in ~/.config/hypr/themes/:
--   common.lua  shared settings (cursor, fonts, glow, scratchpad dimming)
--   theme.lua   the current HyDE theme   (written by themeswitch.sh)
--   colors.lua  wallbash colours         (written by swwwallbash.sh; empty
--               when wallbash is off, so the theme's own colours are used)
-- Each one returns a table:
--   { config = { ...same shape as hl.config... },
--     gsettings = { "gsettings set org.gnome.desktop.interface <key> '<value>'", ... },
--     cursor = { theme = "...", size = N },   -- common.lua only
--     blur_layers = { "waybar" } }            -- layer surfaces to blur
-- Later files win. The gsettings strings are kept as full commands because
-- HyDE's scripts read the GTK/icon theme straight out of those lines.
--
-- They are loaded with dofile, not require, so Hyprland doesn't reload the
-- whole config every time HyDE rewrites them. After a wallpaper change,
-- swwwallbash.sh calls HYDE.reload_colors() through `hyprctl eval`, which
-- applies only the new colours.

local M = {}

local DIR = os.getenv("HOME") .. "/.config/hypr/themes/"

local function load(name)
    local path = DIR .. name .. ".lua"
    local f = io.open(path, "r")
    if not f then
        return {}
    end
    f:close()
    local ok, data = pcall(dofile, path)
    if not ok then
        hl.exec_cmd("notify-send -u critical 'HyDE theme error' " .. require("conf.hyde").q(path .. ": " .. tostring(data)))
        return {}
    end
    return type(data) == "table" and data or {}
end

local function layers()
    return { load("common"), load("theme"), load("colors") }
end

-- gsettings / cursor: only run when something actually changed in this
-- session (they used to run on every reload)
local function state_file()
    local sig = os.getenv("HYPRLAND_INSTANCE_SIGNATURE") or "nosig"
    return (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/hyde-gsettings-" .. sig
end

local function apply_desktop_settings(parts)
    local byKey, order, cursor = {}, {}, nil
    for _, p in ipairs(parts) do
        for _, cmd in ipairs(p.gsettings or {}) do
            local key = cmd:match("gsettings%s+set%s+(%S+%s+%S+)") or cmd
            if byKey[key] == nil then
                table.insert(order, key)
            end
            byKey[key] = cmd
        end
        if p.cursor then
            cursor = p.cursor
        end
    end

    local cmds = {}
    if cursor then
        table.insert(cmds, ("hyprctl setcursor %s %d"):format(cursor.theme, cursor.size))
    end
    for _, key in ipairs(order) do
        table.insert(cmds, byKey[key])
    end
    local joined = table.concat(cmds, " ; ")
    if joined == "" then
        return
    end

    local f = io.open(state_file(), "r")
    local last = f and f:read("a") or nil
    if f then
        f:close()
    end
    if last == joined then
        return
    end

    hl.exec_cmd(joined)
    local out = io.open(state_file(), "w")
    if out then
        out:write(joined)
        out:close()
    end
end

-- whole theme; called on every config load
function M.apply()
    local parts = layers()
    for _, p in ipairs(parts) do
        if p.config then
            hl.config(p.config)
        end
        for _, ns in ipairs(p.blur_layers or {}) do
            hl.layer_rule({ match = { namespace = ns }, blur = true })
        end
    end

    -- On the very first load Hyprland isn't fully up yet (`hyprctl setcursor`
    -- would fail), so wait for the start event. On later reloads the state
    -- file exists and changes are applied right away.
    local f = io.open(state_file(), "r")
    if f then
        f:close()
        apply_desktop_settings(parts)
    else
        hl.on("hyprland.start", function()
            apply_desktop_settings(parts)
        end)
    end
end

-- colours only; called by swwwallbash.sh after a wallpaper change
function M.reload_colors()
    local parts = layers()
    if parts[3].config then
        hl.config(parts[3].config)
    end
    apply_desktop_settings(parts)
    return true
end

return M
