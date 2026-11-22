#!/usr/bin/env bash
# Rebuilds wallpaper thumbnails and colour data for the current theme, then
# re-applies the current wallpaper's colours everywhere (Hyprland, rofi,
# waybar, kitty, GTK, ...). Safe to run any time:   bash tools/repair-colors.sh
set -u
bin="$HOME/.local/share/bin"
cache="$HOME/.cache/hyde"

echo "ImageMagick: $(magick -version 2>/dev/null | head -1 || echo 'NOT FOUND')"
tmp="$(mktemp -d)"
if magick -size 64x64 xc:red "$tmp/t.jpg" 2>/dev/null && magick identify -quiet "$tmp/t.jpg" >/dev/null 2>&1; then
    echo "JPEG write/read: ok"
else
    echo "JPEG write/read: BROKEN in this ImageMagick build (HyDE thumbnails now use PNG, so wallbash still works)"
fi
rm -rf "$tmp"

hydeTheme="$(sed -n 's/^hydeTheme="\(.*\)"/\1/p' "$HOME/.config/hyde/hyde.conf")"
echo "Rebuilding missing/broken thumbnails and colours for theme: $hydeTheme"
bash "$bin/swwwallcache.sh" -t "$hydeTheme" >/dev/null 2>&1

wall="$(readlink -f "$cache/wall.set")"
dcol="$cache/dcols/$(sha1sum "$wall" | cut -d' ' -f1).dcol"
if [ "$(wc -l < "$dcol" 2>/dev/null)" != "89" ]; then
    echo "!! Still no colour data for $(basename "$wall"). Last wallbash errors:"
    tail -n 20 "$cache/wallbash.log" 2>/dev/null
    exit 1
fi

echo "Colour data ok for $(basename "$wall"); re-applying it..."
bash "$bin/swwwallpaper.sh" -s "$wall" >/dev/null 2>&1
sleep 3
if grep -q 'rgba(ff)\|prefer-'"'" "$HOME/.config/hypr/themes/colors.lua" 2>/dev/null; then
    echo "!! colors.lua still has empty colours; see $cache/wallbash.log"
    exit 1
fi
echo "Done: colours regenerated for Hyprland, rofi, waybar and the rest."
