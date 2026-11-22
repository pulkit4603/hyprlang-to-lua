#!/usr/bin/env bash
# Lua port: `hyprctl dispatch` now takes a Lua dispatcher (killactive -> hl.dsp.window.close()).
if [[ $(hyprctl activewindow -j | jq -r ".class") == "Steam" ]]; then
    xdotool windowunmap $(xdotool getactivewindow)
else
    hyprctl dispatch 'hl.dsp.window.close()'
fi
