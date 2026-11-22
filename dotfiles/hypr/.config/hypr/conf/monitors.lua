-- █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
-- █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄
--
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local dev = require("conf.devices")

-- fallback rule: every monitor without its own rule (the laptop panel, eDP-1)
hl.monitor({
    output = "",
    mode = "1920x1080",
    position = "0x20",
    scale = 1,
})

-- external LG monitor, to the left of the laptop, at its full 100Hz
hl.monitor({
    output = dev.external,
    mode = "2560x1440@99.95",
    position = "-2560x0",
    scale = 1,
})
