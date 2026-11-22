-- Shared theme settings (data, applied by conf/theme.lua before the theme
-- and wallbash colours). Was themes/common.conf.

return {
    cursor = { theme = "Bibata-Modern-Ice", size = 20 },

    gsettings = {
        "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'",
        "gsettings set org.gnome.desktop.interface cursor-size 20",
        "gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'",
        "gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'",
        "gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'",
        "gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'",
        "gsettings set org.gnome.desktop.interface font-hinting 'full'",
    },

    config = {
        decoration = {
            dim_special = 0.3,
            blur = {
                special = true,
            },
            -- faint inner glow on the focused window only; the colour comes
            -- from the theme / wallbash accent, inactive windows get none
            glow = {
                enabled = true,
                range = 10,
                render_power = 3,
                color_inactive = "rgba(00000000)",
            },
        },
    },
}
