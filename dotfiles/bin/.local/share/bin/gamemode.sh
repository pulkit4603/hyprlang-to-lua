#!/usr/bin/env sh
# Waybar half of gamemode: pauses (on) or restores (off) waybar's CSS
# animations and restarts waybar. The Hyprland half is in
# ~/.config/hypr/conf/gamemode.lua (Super+Alt+G calls this with on/off).
# Run with no argument it toggles gamemode like the old script did.

if [ -z "$1" ]; then
	exec hyprctl eval 'require("conf.gamemode").toggle()'
fi

# Waybar performance
FILE="$HOME/.config/waybar/style.css"

sed -i 's/\/\* \(.*animation:.*\) \*\//\1/g' $FILE
sed -i 's/\/\* \(.*transition:.*\) \*\//\1/g' $FILE
if [ "$1" = on ]; then
	sed -i 's/^\(.*animation:.*\)$/\/\* \1 \*\//g' $FILE
	sed -i 's/^\(.*transition:.*\)$/\/\* \1 \*\//g' $FILE
fi
killall waybar
waybar >/dev/null 2>&1 &
