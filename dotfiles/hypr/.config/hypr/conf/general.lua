-- █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
-- █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█
--
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- and https://wiki.hypr.land/Configuring/Layouts/Master-Layout/

hl.config({
    dwindle = {
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
        -- variable refresh rate only for fullscreen windows (games, video)
        vrr = 2,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },

    render = {
        -- fullscreen games/videos go straight to the screen when possible
        -- (2 = only for windows that say they're a game or video)
        direct_scanout = 2,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})
