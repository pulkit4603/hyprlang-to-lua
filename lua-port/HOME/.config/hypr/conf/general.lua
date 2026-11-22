-- █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
-- █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█
--
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- and https://wiki.hypr.land/Configuring/Layouts/Master-Layout/

hl.config({
    dwindle = {
        -- pseudotile = true, (removed from Hyprland in 0.55)
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})

-- █▀▄▀█ █ █▀ █▀▀
-- █░▀░█ █ ▄█ █▄▄

hl.config({
    misc = {
        vrr = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- The old `plugin { hyprwinwrap { class = kitty-bg } }` block was dropped:
-- hyprwinwrap is not installed (hyprpm only has Hyprspace), so it did nothing.
