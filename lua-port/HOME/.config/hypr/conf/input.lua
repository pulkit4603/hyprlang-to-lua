-- █ █▄░█ █▀█ █░█ ▀█▀
-- █ █░▀█ █▀▀ █▄█ ░█░
--
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    input = {
        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.2,
        },

        sensitivity = 0.5,
        force_no_accel = false,
        numlock_by_default = true,

        -- Keyboard
        kb_options = "compose:ralt",
        kb_layout = "us",
    },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
-- (touchpadtoggle.sh on F6 switches the first one on/off at runtime)

hl.device({
    name = "asup1204:00-093a:2642-touchpad",
    sensitivity = 0.3,
})

hl.device({
    name = "compx-2.4g-receiver-mouse",
    sensitivity = -0.5,
})

-- was: gesture = 3, horizontal, workspace
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
