#!/usr/bin/env bash
# Puts the old hyprlang config back exactly as it was before install.sh ran.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
backup="${1:-$(cat "$HOME/.config/hypr/.lua-port-backup" 2>/dev/null || true)}"
[ -f "$backup" ] || { echo "Backup not found. Usage: rollback.sh ~/hypr-lua-port-backup-XXXX.tar.gz"; exit 1; }

# remove the Lua files first so nothing new is left behind in ~/.config/hypr
rm -f "$HOME/.config/hypr/hyprland.lua"
rm -rf "$HOME/.config/hypr/conf"
rm -f "$HOME/.config/hypr/themes/"{common,theme,colors}.lua
python3 "$here/patch-in-place.py" --undo || true
(cd "$HOME" && tar xzf "$backup")
echo "Restored from $backup"
echo "Now log out and back in, or run: hyprctl reload full-reset"
