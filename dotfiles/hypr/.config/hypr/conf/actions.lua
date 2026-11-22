-- Lua versions of the little scripts that used to sit behind some binds.
-- They do exactly what the scripts did, without starting a shell, hyprctl
-- and jq on every key press. The old scripts are still in ~/.local/share/bin.

local dev = require("conf.devices")

local A = {}

---------------------------------------------------------------------------
-- Super+Q / Alt+F4 (was dontkillsteam.sh):
-- close the focused window, except Steam, which is only hidden so it keeps
-- running in the tray.
---------------------------------------------------------------------------
function A.close_active()
    local w = hl.get_active_window()
    if w and w.class == "Steam" then
        hl.exec_cmd("xdotool windowunmap $(xdotool getactivewindow)")
    else
        hl.dispatch(hl.dsp.window.close())
    end
end

---------------------------------------------------------------------------
-- Super+Shift+F (was windowpin.sh):
-- pin the focused window (floating it first if needed); unpinning a window
-- that was floated just for pinning puts it back in the tiling layout.
---------------------------------------------------------------------------
function A.toggle_pin()
    local w = hl.get_active_window()
    if not w then
        return
    end
    if not w.floating and not w.pinned then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end

    hl.dispatch(hl.dsp.window.pin())

    if w.floating and not w.pinned then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    end
end

---------------------------------------------------------------------------
-- F6 (was touchpadtoggle.sh): same status file and notifications as before.
---------------------------------------------------------------------------
local function touchpad_status_file()
    return (os.getenv("XDG_RUNTIME_DIR") or "/tmp") .. "/touchpad.status"
end

-- true unless F6 turned it off earlier in this login session
function A.touchpad_enabled()
    local f = io.open(touchpad_status_file(), "r")
    if not f then
        return true
    end
    local s = f:read("l")
    f:close()
    return s ~= "false"
end

function A.toggle_touchpad()
    -- same order as the script: no status file yet -> disable
    local f = io.open(touchpad_status_file(), "r")
    local cur = f and f:read("l") or nil
    if f then
        f:close()
    end
    local enable = (cur == "false")

    local out = io.open(touchpad_status_file(), "w")
    if out then
        out:write(enable and "true" or "false")
        out:close()
    end

    hl.exec_cmd(enable and "notify-send -u normal 'Enabling Touchpad'" or "notify-send -u normal 'Disabling Touchpad'")
    hl.device({ name = dev.touchpad, enabled = enable })
end

---------------------------------------------------------------------------
-- Ctrl+Alt+arrows: rotate the laptop panel. Same monitor rule as the old
-- `hyprctl keyword monitor eDP-1,preferred,auto,1,transform,N`; Up and Down
-- applied it twice before, and still do.
---------------------------------------------------------------------------
function A.rotate(transform, times)
    return function()
        for _ = 1, (times or 1) do
            hl.monitor({
                output = dev.laptop_panel,
                mode = "preferred",
                position = "auto",
                scale = 1,
                transform = transform,
            })
        end
    end
end

return A
