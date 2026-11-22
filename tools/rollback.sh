#!/usr/bin/env bash
# Undoes tools/update.sh: removes the symlinks and restores the backup it made.
#     bash tools/rollback.sh [backup.tar.gz]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dot="$(cd "$here/.." && pwd)/dotfiles"
backup="${1:-$(cat "$HOME/.config/hypr/.dotfiles-backup" 2>/dev/null || true)}"
[ -f "$backup" ] || { echo "Backup not found. Usage: rollback.sh ~/hypr-dotfiles-backup-XXXX.tar.gz"; exit 1; }

stow -D -d "$dot" -t "$HOME" hypr hyde bin systemd
(cd "$HOME" && tar xzf "$backup")
systemctl --user daemon-reload 2>/dev/null || echo "(systemd user manager not reachable; run: systemctl --user daemon-reload)"
echo "Restored from $backup. Log out and back in."
