-- █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
-- █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄
--
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
--
-- Same as before:
--   monitor= ,1920x1080,0x20,1,
--   monitor= HDMI-A-1,2560x1440,-2560x0,1,
--
-- (The old `env = bitdepth,10` line did nothing, it only created an environment
-- variable called "bitdepth", so it has been dropped. If you ever want 10-bit
-- output, add `bitdepth = 10` to a monitor below.)

-- fallback rule: every monitor without its own rule (that is your laptop panel, eDP-1)
hl.monitor({
    output = "",
    mode = "1920x1080",
    position = "0x20",
    scale = 1,
})

-- external LG monitor, to the left of the laptop
-- (it also supports 2560x1440@99.95Hz if you ever want: mode = "2560x1440@99.95")
hl.monitor({
    output = "HDMI-A-1",
    mode = "2560x1440",
    position = "-2560x0",
    scale = 1,
})

-- other commented-out lines from the old file, kept for reference:
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, bitdepth = 10 })
-- hl.monitor({ output = "", mode = "1920x1080", position = "2560x0", scale = 1, bitdepth = 10 })
-- hl.monitor({ output = "eDP-1", mode = "2880x1800@90", position = "0x0", scale = 1, bitdepth = 10 })
