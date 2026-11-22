#!/usr/bin/env bash
# Puts the machine back on the plain Lua port (lua-port/), undoing the
# stow/systemd/theme-engine setup from backup/stow-v2. Works before or after
# `git pull`. Run it from a terminal inside Hyprland, then log out and back in.
#     bash lua-port/tools/revert-from-stow.sh
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/../.." && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

# 1. keep a copy of the current (stow) state, just in case
state="$HOME/hypr-stow-v2-state-$stamp.tar.gz"
(cd "$HOME" && tar czf "$state" .config/hypr .local/share/bin .config/hyde/themes .config/hyde/wallbash/Wall-Dcol $( [ -d .config/systemd/user ] && echo .config/systemd/user ) 2>/dev/null)
echo "Current state saved: $state"

# 2. stop the systemd helpers (the Lua port starts these itself at login)
systemctl --user stop hyde-session.target 'hyde-*.service' 2>/dev/null || true

# 3. remove every symlink that points into a dotfiles/ folder (even dangling ones)
removed=0
while IFS= read -r -d '' link; do
    case "$(readlink "$link")" in
        */dotfiles/*) rm -f "$link"; removed=$((removed + 1)) ;;
    esac
done < <(find "$HOME/.config/hypr" "$HOME/.local/share/bin" "$HOME/.config/hyde" "$HOME/.config/systemd/user" -type l -print0 2>/dev/null)
echo "Removed $removed links into the repo."

# 4. restore the state from before tools/update.sh first ran (= the Lua port)
backup="$(cat "$HOME/.config/hypr/.dotfiles-backup" 2>/dev/null || true)"
if [ -f "$backup" ]; then
    (cd "$HOME" && tar xzf "$backup")
    rm -f "$HOME/.config/hypr/.dotfiles-backup"
    echo "Restored the Lua port from $backup"
else
    echo "No update.sh backup found; reinstalling the Lua port from the repo instead."
    mkdir -p "$HOME/.local/share/bin"
    for f in "$repo/home-pulkit-.local-share-bin/"*; do
        n="$(basename "$f")"; [ -e "$HOME/.local/share/bin/$n" ] || cp "$f" "$HOME/.local/share/bin/$n"
    done
    chmod +x "$HOME/.local/share/bin/"*
    bash "$here/install.sh"
fi

systemctl --user daemon-reload 2>/dev/null || true
cat <<MSG

Done. Log out and log back in now (either Hyprland session works).
Then run:  bash $here/verify-binds.sh
MSG
