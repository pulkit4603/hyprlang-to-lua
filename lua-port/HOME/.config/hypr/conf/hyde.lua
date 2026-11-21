-- Small shared helpers used by the rest of the config and by the HyDE theme
-- files (themes/theme.lua, themes/colors.lua). `require("conf.hyde")` returns
-- the same table everywhere during one config load.

local M = {}

M.home = os.getenv("HOME")
M.scrPath = M.home .. "/.local/share/bin" -- was: $scrPath = $HOME/.local/share/bin

-- path to a HyDE script, e.g. M.scr("dontkillsteam.sh")
function M.scr(name)
    return M.scrPath .. "/" .. name
end

---------------------------------------------------------------------------
-- gsettings queue
--
-- Theme files call M.gsettings("gsettings set org.gnome.desktop.interface gtk-theme 'X'").
-- The full command string is kept verbatim on purpose: HyDE's shell scripts
-- (themeswitch.sh, wbarconfgen.sh, logoutlaunch.sh, swwwallbash.sh) grep the
-- theme files for exactly that text to find the GTK/icon theme and colour scheme.
--
-- If the same key is set twice (theme.lua and then colors.lua), the later one
-- wins. All commands then run one after another in hyprland.lua.
---------------------------------------------------------------------------

function M.reset()
    M._gs = {}
    M._gsOrder = {}
end

function M.gsettings(cmd)
    if not M._gs then
        M.reset()
    end
    local key = cmd:match("gsettings%s+set%s+(%S+%s+%S+)") or cmd
    if M._gs[key] == nil then
        table.insert(M._gsOrder, key)
    end
    M._gs[key] = cmd
end

function M.flush_gsettings()
    if not M._gsOrder or #M._gsOrder == 0 then
        return
    end
    local cmds = {}
    for _, key in ipairs(M._gsOrder) do
        table.insert(cmds, M._gs[key])
    end
    -- same as the old `exec =` lines: runs on every config load/reload
    hl.exec_cmd(table.concat(cmds, " ; "))
end

return M
