#!/usr/bin/env bash
# Moves your installed Lua config onto symlinks into this repo (GNU Stow) and
# brings in the new changes. Run it on the Linux machine, from anywhere:
#     bash tools/update.sh
# It edits what's already installed instead of adding a second copy:
#   - everything it touches is backed up first (~/hypr-dotfiles-backup-<time>.tar.gz)
#   - installed copies are replaced by symlinks into dotfiles/ (nothing left twice)
#   - running it again changes nothing
# Undo with tools/rollback.sh.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
dot="$repo/dotfiles"
pkgs=(hypr hyde bin systemd)

command -v stow >/dev/null || { echo "GNU Stow is needed first:  sudo pacman -S stow"; exit 1; }

# don't let Hyprland reload half-replaced files while this runs
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl eval 'hl.config({ misc = { disable_autoreload = true } })' >/dev/null 2>&1 || true
fi

# -------------------------------------------------------------- 1. backup
stamp="$(date +%Y%m%d-%H%M%S)"
backup="$HOME/hypr-dotfiles-backup-$stamp.tar.gz"
list=()
for d in .config/hypr .local/share/bin .config/systemd/user; do
    [ -e "$HOME/$d" ] && list+=("$d")
done
while IFS= read -r rel; do
    [ -e "$HOME/$rel" ] && list+=("$rel")
done < <(cd "$dot/hyde" && find . -type f | sed 's|^\./||')
(cd "$HOME" && tar czf "$backup" "${list[@]}")
echo "Backup: $backup"
# rollback.sh restores the backup from the FIRST run (before any symlinks)
[ -f "$HOME/.config/hypr/.dotfiles-backup" ] || echo "$backup" > "$HOME/.config/hypr/.dotfiles-backup"

# -------------------------------------------------------------- 2. scripts only on this machine
# HyDE's scripts find each other through their real location, so every script
# in ~/.local/share/bin has to live in the repo once they become symlinks.
bin_pkg="$dot/bin/.local/share/bin"
adopted=()
for f in "$HOME/.local/share/bin/"*; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    case "$name" in *.hyprlang.bak) continue ;; esac
    [ -L "$f" ] && continue
    if [ ! -e "$bin_pkg/$name" ]; then
        cp -p "$f" "$bin_pkg/$name"
        adopted+=("$name")
    fi
done
chmod +x "$bin_pkg/"*.sh "$bin_pkg/"*.py 2>/dev/null || true

# -------------------------------------------------------------- 3. make room for the symlinks
# (every file removed here is in the backup)
removed=0
for pkg in "${pkgs[@]}"; do
    while IFS= read -r rel; do
        target="$HOME/$rel"
        src="$dot/$pkg/$rel"
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$src")" ]; then
            continue # already linked
        fi
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -f "$target"
            removed=$((removed + 1))
        fi
    done < <(cd "$dot/$pkg" && find . -type f | sed 's|^\./||')
done
rm -f "$HOME/.local/share/bin/"*.hyprlang.bak

# -------------------------------------------------------------- 4. link
stow --no-folding -R -d "$dot" -t "$HOME" "${pkgs[@]}"
echo "Linked ${pkgs[*]} (replaced $removed installed files with symlinks)."

# -------------------------------------------------------------- 5. regenerate the theme data
# theme.lua / colors.lua are generated files (not in the repo); the new config
# expects them as data, so rebuild them from the current theme and wallpaper.
hydeTheme="$(sed -n 's/^hydeTheme="\(.*\)"/\1/p' "$HOME/.config/hyde/hyde.conf")"
enableWallDcol="$(sed -n 's/^enableWallDcol="\(.*\)"/\1/p' "$HOME/.config/hyde/hyde.conf")"
sed '1d' "$HOME/.config/hyde/themes/$hydeTheme/hypr.theme" > "$HOME/.config/hypr/themes/theme.lua"
if [ "${enableWallDcol:-0}" -gt 0 ]; then
    wall="$(readlink -f "$HOME/.cache/hyde/wall.set")"
    # same as a normal wallpaper change, minus talking to the running Hyprland
    env -u HYPRLAND_INSTANCE_SIGNATURE bash "$HOME/.local/share/bin/swwwallbash.sh" "$wall" >/dev/null 2>&1 || true
else
    : > "$HOME/.config/hypr/themes/colors.lua"
fi
for f in theme colors; do
    p="$HOME/.config/hypr/themes/$f.lua"
    if [ -s "$p" ] && ! grep -q '^return {' "$p"; then
        echo "!! $p was not regenerated in the new format, see README (Troubleshooting)."
    fi
done
echo "Theme data regenerated (theme: $hydeTheme)."

# -------------------------------------------------------------- 6. systemd
systemctl --user daemon-reload 2>/dev/null || echo "(systemd user manager not reachable; run: systemctl --user daemon-reload)"

# -------------------------------------------------------------- done
if [ ${#adopted[@]} -gt 0 ]; then
    echo
    echo "These scripts existed only on this machine and were copied into the repo:"
    printf '    %s\n' "${adopted[@]}"
    echo "Commit them (dotfiles/bin/.local/share/bin/)."
fi
cat <<MSG

Done. Now:
  1. Log out.
  2. Log back in with the uwsm session ("Hyprland (uwsm-managed)" in SDDM;
     from a TTY: uwsm start hyprland.desktop). The plain session works too.
  3. Run:  bash $here/verify-binds.sh
Undo:  bash $here/rollback.sh
MSG
command -v uwsm >/dev/null || echo "(uwsm isn't installed yet:  sudo pacman -S uwsm)"
