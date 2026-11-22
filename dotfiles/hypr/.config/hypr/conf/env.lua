-- █▀▀ █▄░█ █░█
-- ██▄ █░▀█ ▀▄▀
--
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local hyde = require("conf.hyde")

-- was: env = PATH,$PATH:$scrPath
-- (only appended once, so reloading the config doesn't keep growing PATH)
local path = os.getenv("PATH") or ""
if not (":" .. path .. ":"):find(":" .. hyde.scrPath .. ":", 1, true) then
    hl.env("PATH", path .. ":" .. hyde.scrPath)
end

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
