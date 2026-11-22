-- HyDE theme: Rule One
-- Lua port (Hyprland 0.56+). Deployed by HyDE to ~/.config/hypr/themes/*.lua.
local hyde = require("conf.hyde")
hyde.gsettings("gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-green'")
hyde.gsettings("gsettings set org.gnome.desktop.interface gtk-theme 'Decay-Green'")
hyde.gsettings("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border = { colors = { "rgba(90ceaaff)", "rgba(ecd3a0ff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(86aaeccc)", "rgba(93cee9cc)" }, angle = 45 },
        },
        layout = "dwindle",
        resize_on_border = true,
    },
    group = {
        col = {
            border_active = { colors = { "rgba(90ceaaff)", "rgba(ecd3a0ff)" }, angle = 45 },
            border_inactive = { colors = { "rgba(86aaeccc)", "rgba(93cee9cc)" }, angle = 45 },
            border_locked_active = { colors = { "rgba(90ceaaff)", "rgba(ecd3a0ff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(86aaeccc)", "rgba(93cee9cc)" }, angle = 45 },
        },
    },
    decoration = {
        rounding = 2,
        shadow = {
            enabled = false, -- was: drop_shadow = false
        },
        blur = {
            enabled = false,
            size = 5,
            passes = 4,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
        },
    },
})

-- was: layerrule = unset,waybar  (no blur on waybar; nothing to set)
