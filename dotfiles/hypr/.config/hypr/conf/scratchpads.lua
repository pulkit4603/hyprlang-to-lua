-- Scratchpads (special workspaces) open as an inset panel: a gap all around
-- so they float over the dimmed workspace below. Normal workspaces stay
-- gapless (Rule One). The slide-in animation is in animations.lua.

local SCRATCHPADS = { "spotifyWin", "dekhoWin", "kaamWin", "notetakerWin", "chatgptWin" }

for _, name in ipairs(SCRATCHPADS) do
    hl.workspace_rule({
        workspace = "special:" .. name,
        gaps_out = 48,
        gaps_in = 0,
    })
end
