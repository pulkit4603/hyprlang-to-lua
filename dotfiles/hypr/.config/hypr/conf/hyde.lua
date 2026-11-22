-- Small shared helpers: paths to HyDE's scripts.

local M = {}

M.home = os.getenv("HOME")
M.scrPath = M.home .. "/.local/share/bin" -- was: $scrPath = $HOME/.local/share/bin

-- path to a HyDE script, e.g. M.scr("screenshot.sh")
function M.scr(name)
    return M.scrPath .. "/" .. name
end

-- shell-quote a string with single quotes
function M.q(s)
    return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

return M
