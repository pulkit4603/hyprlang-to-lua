-- █ █▄░█ █▀█ █░█ ▀█▀
-- █ █░▀█ █▀▀ █▄█ ░█░
--
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local dev = require("conf.devices")
local actions = require("conf.actions")

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

hl.device({
    name = dev.touchpad,
    sensitivity = 0.3,
    -- F6 turns the touchpad off/on and remembers it; a config reload used to
    -- silently switch it back on, now it stays the way you left it.
    enabled = actions.touchpad_enabled(),
})

hl.device({
    name = dev.mouse,
    sensitivity = -0.5,
})

-- was: gesture = 3, horizontal, workspace
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
