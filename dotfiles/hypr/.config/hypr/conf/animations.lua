-- ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
-- █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█
--
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Same animations as before, with three changes: windows move on a spring,
-- closing windows fade out briefly, and scratchpads slide in vertically.
-- None of this adds work while nothing is animating.

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("wind", { type = "bezier", points = { { 0, 1 }, { 0, 1 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.5, 0 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

-- a quick spring that settles with almost no bounce
-- (more stiffness = faster, more dampening = less bounce)
hl.curve("snap", { type = "spring", mass = 1, stiffness = 90, dampening = 18 })

hl.animation({ leaf = "windows", enabled = true, speed = 6, spring = "snap", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, spring = "snap", style = "popin 98%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, spring = "snap", style = "slide" })

-- closing: a short fade (~150ms) instead of vanishing instantly
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "winOut", style = "popin 100%" })

-- hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
-- hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "default" }) -- closing fade (~150ms)
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "wind" })

-- scratchpads (special workspaces) slide in vertically
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, spring = "snap", style = "slidevert" })
