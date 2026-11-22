-- █▀▀ █░█ █▀█ █▀ █▀█ █▀█
-- █▄▄ █▄█ █▀▄ ▄█ █▄█ █▀▄
--
-- Shared theme settings (was themes/common.conf). Like the old `exec =` lines,
-- these run on every config load.

local hyde = require("conf.hyde")

hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")
hyde.gsettings("gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'")
hyde.gsettings("gsettings set org.gnome.desktop.interface cursor-size 20")

-- █▀▀ █▀█ █▄░█ ▀█▀
-- █▀░ █▄█ █░▀█ ░█░

hyde.gsettings("gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'")
hyde.gsettings("gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'")
hyde.gsettings("gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'")
hyde.gsettings("gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'")
hyde.gsettings("gsettings set org.gnome.desktop.interface font-hinting 'full'")

-- █▀ █▀█ █▀▀ █▀▀ █ ▄▀█ █░░
-- ▄█ █▀▀ ██▄ █▄▄ █ █▀█ █▄▄

hl.config({
    decoration = {
        dim_special = 0.3,
        blur = {
            special = true,
        },
    },
})
