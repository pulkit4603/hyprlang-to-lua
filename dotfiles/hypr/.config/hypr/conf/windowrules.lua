-- █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
-- ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█
--
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Same rules as before, written as tables. To add an app, add one line.

-- opacity = "active inactive"; the list holds class patterns
-- (or { initial_title = "..." } for rules that match the title instead)
local OPACITY = {
    ["0.90 0.90"] = {
        "^(Mysql-workbench-bin)",
        "^(org.pwmt.zathura)$",
        "^(Brave-browser)$",
        "^([Cc]ode)$",
        "^(com.github.rafostar.Clapper)$",
    },
    ["0.95 0.95"] = {
        "^([Ff]irefox)$",
        "^(zen-alpha)$",
    },
    ["0.75 0.75"] = {
        "^(obsidian)$",
    },
    ["0.80 0.80"] = {
        "^(code-oss)$",
        "^(code-url-handler)$",
        "^(code-insiders-url-handler)$",
        "^(org.kde.dolphin)$",
        "^(org.kde.ark)$",
        "^(nwg-look)$",
        "^(qt5ct)$",
        "^(qt6ct)$",
        "^(kvantummanager)$",
        "^(com.github.tchx84.Flatseal)$",
        "^(hu.kramo.Cartridges)$",
        "^(com.obsproject.Studio)$",
        "^(gnome-boxes)$",
        "^(vesktop)$",
        "^(discord)$",
        "^(WebCord)$",
        "^(ArmCord)$",
        "^(app.drey.Warp)$",
        "^(net.davidotek.pupgui2)$",
        "^(yad)$",
        "^(Signal)$",
        "^(io.github.alainm23.planify)$",
        "^(io.gitlab.theevilskeleton.Upscaler)$",
        "^(com.github.unrud.VideoDownloader)$",
        "^(io.gitlab.adhami3310.Impression)$",
        "^(io.missioncenter.MissionCenter)$",
        "^(io.github.flattool.Warehouse)$",
    },
    ["0.85 0.85"] = {
        "^(kitty)$",
    },
    ["0.80 0.70"] = {
        "^(org.pulseaudio.pavucontrol)$",
        "^(blueman-manager)$",
        "^(nm-applet)$",
        "^(nm-connection-editor)$",
        "^(org.kde.polkit-kde-authentication-agent-1)$",
        "^(polkit-gnome-authentication-agent-1)$",
        "^(org.freedesktop.impl.portal.desktop.gtk)$",
        "^(org.freedesktop.impl.portal.desktop.hyprland)$",
    },
    ["0.70 0.70"] = {
        "^([Ss]team)$",
        "^(steamwebhelper)$",
        "^([Ss]potify)$",
        { initial_title = "^(Spotify Free)$" },
        { initial_title = "^(Spotify Premium)$" },
    },
}

-- windows that should open floating: a class pattern, or a table of matches
local FLOAT = {
    { class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" },
    { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" },
    { title = "^(About Mozilla Firefox)$" },
    { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
    { class = "^(firefox)$", title = "^(Library)$" },
    { class = "^(kitty)$", title = "^(top)$" },
    { class = "^(kitty)$", title = "^(btop)$" },
    { class = "^(kitty)$", title = "^(htop)$" },
    "^(vlc)$",
    "^(kvantummanager)$",
    "^(qt5ct)$",
    "^(qt6ct)$",
    "^(nwg-look)$",
    "^(org.kde.ark)$",
    "^(org.pulseaudio.pavucontrol)$",
    "^(blueman-manager)$",
    "^(nm-applet)$",
    "^(nm-connection-editor)$",
    "^(org.kde.polkit-kde-authentication-agent-1)$",
    "^(Signal)$", -- Signal-Gtk
    "^(com.github.rafostar.Clapper)$", -- Clapper-Gtk
    "^(app.drey.Warp)$", -- Warp-Gtk
    "^(net.davidotek.pupgui2)$", -- ProtonUp-Qt
    "^(yad)$", -- Protontricks-Gtk
    "^(eog)$", -- Imageviewer-Gtk
    "^(io.github.alainm23.planify)$", -- planify-Gtk
    "^(io.gitlab.theevilskeleton.Upscaler)$", -- Upscaler-Gtk
    "^(com.github.unrud.VideoDownloader)$", -- VideoDownloader-Gkk
    "^(io.gitlab.adhami3310.Impression)$", -- Impression-Gtk
    "^(io.missioncenter.MissionCenter)$", -- MissionCenter-Gtk
    { title = "^(Open)$" },
    { title = "^(Choose Files)$" },
    { title = "^(Save As)$" },
    { title = "^(Confirm to replace files)$" },
    { title = "^(File Operation Progress)$" },
    "^(xdg-desktop-portal-gtk)$",
}

-- layer surfaces (rofi, notifications, logout menu)
local LAYERS = {
    ["rofi"] = { blur = true, ignore_alpha = 0 },
    ["notifications"] = { blur = true, ignore_alpha = 0 },
    ["swaync-notification-window"] = { blur = true, ignore_alpha = 0 },
    ["swaync-control-center"] = { blur = true, ignore_alpha = 0 },
    ["logout_dialog"] = { blur = true },
}

local function as_match(entry)
    if type(entry) == "string" then
        return { class = entry }
    end
    return entry
end

-- pairs() has no fixed order; sort the opacity values so rules are always
-- added in the same order (no two of them apply to the same window anyway)
local values = {}
for value in pairs(OPACITY) do
    table.insert(values, value)
end
table.sort(values)
for _, value in ipairs(values) do
    for _, entry in ipairs(OPACITY[value]) do
        hl.window_rule({ match = as_match(entry), opacity = value })
    end
end

for _, entry in ipairs(FLOAT) do
    hl.window_rule({ match = as_match(entry), float = true })
end

for namespace, effects in pairs(LAYERS) do
    local rule = { match = { namespace = namespace } }
    for k, v in pairs(effects) do
        rule[k] = v
    end
    hl.layer_rule(rule)
end

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
