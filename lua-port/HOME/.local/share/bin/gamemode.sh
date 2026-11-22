#!/usr/bin/env sh
# Lua port: `hyprctl keyword` doesn't work with a Lua config, so the effects are
# switched off with `hyprctl eval` instead. `decoration:drop_shadow` no longer
# exists; shadows are `decoration.shadow.enabled` now (so this actually turns
# them off again).
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')
# animations:enabled is a bool; depending on the version it prints 1/0 or true/false
case "$HYPRGAMEMODE" in
    1|true) HYPRGAMEMODE=1 ;;
    *) HYPRGAMEMODE=0 ;;
esac

# Waybar performance
FILE="$HOME/.config/waybar/style.css"

sed -i 's/\/\* \(.*animation:.*\) \*\//\1/g' $FILE
sed -i 's/\/\* \(.*transition:.*\) \*\//\1/g' $FILE
if [ $HYPRGAMEMODE = 1 ]; then
	sed -i 's/^\(.*animation:.*\)$/\/\* \1 \*\//g' $FILE
	sed -i 's/^\(.*transition:.*\)$/\/\* \1 \*\//g' $FILE
fi
killall waybar
waybar >/dev/null 2>&1 &

# Hyprland performance
if [ $HYPRGAMEMODE = 1 ]; then
	hyprctl eval 'hl.config({
        animations = { enabled = false },
        decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 },
        general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
    })'
	exit
else
	hyprctl reload
fi
