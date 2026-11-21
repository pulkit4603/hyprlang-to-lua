#!/usr/bin/env bash
# Installs the Lua port on the Linux machine. Run from anywhere:
#   bash lua-port/tools/install.sh
# 1. backs up everything it will touch into ~/hypr-lua-port-backup-<time>.tar.gz
# 2. copies lua-port/HOME/* into your home folder (old .conf files are left in place)
# 3. applies the small in-place edits (patch-in-place.py)
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
src="$(cd "$here/../HOME" && pwd)"

ver="$(hyprctl version 2>/dev/null | head -1 || true)"
echo "Hyprland: ${ver:-unknown (not running?)}"
case "$ver" in
    *" 0.5"[5-9]*|*" 0.6"*) ;;
    *) echo "!! This port needs Hyprland 0.55 or newer (Lua configs)."; read -rp "Continue anyway? [y/N] " a; [ "$a" = y ] || exit 1 ;;
esac

stamp="$(date +%Y%m%d-%H%M%S)"
backup="$HOME/hypr-lua-port-backup-$stamp.tar.gz"

# everything this installer may overwrite (relative to $HOME), plus the whole hypr folder
mapfile -t files < <(cd "$src" && find . -type f | sed 's|^\./||')
list=(.config/hypr)
for f in "${files[@]}"; do [ -e "$HOME/$f" ] && list+=("$f"); done
for f in .local/share/bin/swwwallbash.sh .local/share/bin/themeswitch.sh .local/share/bin/swwwallpaper.sh \
         .local/share/bin/wbarstylegen.sh .local/share/bin/gamelauncher.sh .local/share/bin/sysmonlaunch.sh \
         .config/waybar/config.jsonc .config/waybar/modules/updates.jsonc .config/waybar/modules/workspaces.jsonc \
         .config/wlogout/layout_1 .config/wlogout/layout_2; do
    [ -e "$HOME/$f" ] && list+=("$f")
done
(cd "$HOME" && tar czf "$backup" "${list[@]}")
echo "Backup written: $backup"

# copy files (keeps hyprland.conf etc. so you can roll back)
(cd "$src" && for f in "${files[@]}"; do
    mkdir -p "$HOME/$(dirname "$f")"
    cp -f "$f" "$HOME/$f"
done)
chmod +x "$HOME/.local/share/bin/"{dontkillsteam,windowpin,gamemode,touchpadtoggle,wallbashqt}.sh
echo "Copied ${#files[@]} files."

python3 "$here/patch-in-place.py"

echo "$backup" > "$HOME/.config/hypr/.lua-port-backup"
cat <<MSG

Done. Hyprland picks hyprland.lua over hyprland.conf.
Now either log out and back in (cleanest), or run:
    hyprctl reload full-reset
Then check everything with:
    bash $here/verify-binds.sh
To go back to the old config:
    bash $here/rollback.sh
MSG
