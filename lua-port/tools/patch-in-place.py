#!/usr/bin/env python3
"""
Small, exact edits to files that are too long to ship whole (or that live
outside this repo): five HyDE scripts, waybar modules and wlogout layouts.

Every edit is an exact text replacement. Before changing a file, a copy is
saved next to it as <file>.hyprlang.bak (only the first time). If the old text
isn't found and the new text isn't there either, the file is left alone and
the script tells you, so nothing is ever half-edited.

Run it once on the Linux machine:   python3 patch-in-place.py
Undo:                                python3 patch-in-place.py --undo
"""

import os
import shutil
import sys

HOME = os.path.expanduser("~")
BIN = os.path.join(HOME, ".local/share/bin")
CFG = os.path.join(HOME, ".config")

AUTORELOAD_OFF = "hyprctl eval 'hl.config({ misc = { disable_autoreload = true } })' > /dev/null"

EDITS = [
    # ---------------------------------------------------------------- swwwallbash.sh
    (
        f"{BIN}/swwwallbash.sh",
        """[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] &&  hyprctl keyword misc:disable_autoreload 1 -q && trap 'hyprctl reload -q && echo "[swwwallbash] reload :: Hyprland"' EXIT""",
        f"""# Lua port: `hyprctl keyword` doesn't work with a Lua config -> `hyprctl eval`
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] ; then
    {AUTORELOAD_OFF}
    trap 'hyprctl reload -q && echo "[swwwallbash] reload :: Hyprland"' EXIT
fi""",
    ),
    # ---------------------------------------------------------------- themeswitch.sh
    (
        f"{BIN}/themeswitch.sh",
        """[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] &&  hyprctl keyword misc:disable_autoreload 1 -q""",
        f"""[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && {AUTORELOAD_OFF} # Lua port: keyword -> eval""",
    ),
    (
        f"{BIN}/themeswitch.sh",
        """sed '1d' "${hydeThemeDir}/hypr.theme" > "${confDir}/hypr/themes/theme.conf\"""",
        """sed '1d' "${hydeThemeDir}/hypr.theme" > "${confDir}/hypr/themes/theme.lua\"""",
    ),
    # ---------------------------------------------------------------- swwwallpaper.sh
    # $hyprconfDir was never defined, so this sed always failed. Now it points at
    # the real hyprlock.conf and only replaces the first `path =` (the
    # background), so the avatar image stays as it is.
    (
        f"{BIN}/swwwallpaper.sh",
        """sed -i 's|path = .*$|path = '"$(readlink "${wallSet}")"'|' "${hyprconfDir}/hyprlock.conf\"""",
        """sed -i '0,/^\\s*path = /s|^\\(\\s*\\)path = .*$|\\1path = '"$(readlink "${wallSet}")"'|' "${confDir}/hypr/hyprlock.conf\"""",
    ),
    # ---------------------------------------------------------------- wbarstylegen.sh
    (
        f"{BIN}/wbarstylegen.sh",
        """src_file="${confDir}/hypr/themes/theme.conf\"""",
        """src_file="${confDir}/hypr/themes/theme.lua\"""",
    ),
    (
        f"{BIN}/wbarstylegen.sh",
        """hypr_border=`awk -F '=' '{if($1~" rounding ") print $2}' $src_file | sed 's/ //g'`""",
        """hypr_border=`awk -F '=' '$1 ~ /^[[:space:]]*rounding[[:space:]]*$/ {gsub(/[^0-9]/, "", $2); print $2; exit}' "$src_file"`""",
    ),
    # ---------------------------------------------------------------- gamelauncher.sh
    (
        f"{BIN}/gamelauncher.sh",
        """ThemeSet="${confDir}/hypr/themes/theme.conf\"""",
        """ThemeSet="${confDir}/hypr/themes/theme.lua\"""",
    ),
    # ---------------------------------------------------------------- sysmonlaunch.sh
    # Ctrl+Shift+Escape: the terminal name used to be read from keybindings.conf
    (
        f"{BIN}/sysmonlaunch.sh",
        """term=$(cat $HOME/.config/hypr/keybindings.conf | grep ^'$term' | cut -d '=' -f2)""",
        """term=$(grep -m1 '^local term' $HOME/.config/hypr/conf/keybindings.lua | cut -d '"' -f2)""",
    ),
    # ---------------------------------------------------------------- waybar
    (
        f"{CFG}/waybar/modules/updates.jsonc",
        """"on-click": "hyprctl dispatch exec 'systemupdate.sh up'",""",
        """"on-click": "hyprctl dispatch 'hl.dsp.exec_cmd(\\"systemupdate.sh up\\")'",""",
    ),
    (
        f"{CFG}/waybar/config.jsonc",
        """"on-click": "hyprctl dispatch exec 'systemupdate.sh up'",""",
        """"on-click": "hyprctl dispatch 'hl.dsp.exec_cmd(\\"systemupdate.sh up\\")'",""",
    ),
    (
        f"{CFG}/waybar/modules/workspaces.jsonc",
        """"on-scroll-up": "hyprctl dispatch workspace -1",""",
        """"on-scroll-up": "hyprctl dispatch 'hl.dsp.focus({ workspace = \\"-1\\" })'",""",
    ),
    (
        f"{CFG}/waybar/modules/workspaces.jsonc",
        """"on-scroll-down": "hyprctl dispatch workspace +1",""",
        """"on-scroll-down": "hyprctl dispatch 'hl.dsp.focus({ workspace = \\"+1\\" })'",""",
    ),
    # ---------------------------------------------------------------- wlogout
    (
        f"{CFG}/wlogout/layout_1",
        """"action" : "hyprctl dispatch exit 0",""",
        """"action" : "hyprctl dispatch 'hl.dsp.exit()'",""",
    ),
    (
        f"{CFG}/wlogout/layout_2",
        """"action" : "hyprctl dispatch exit 0",""",
        """"action" : "hyprctl dispatch 'hl.dsp.exit()'",""",
    ),
]


def undo():
    seen = set()
    for path, _, _ in EDITS:
        if path in seen:
            continue
        seen.add(path)
        bak = path + ".hyprlang.bak"
        if os.path.exists(bak):
            shutil.copy2(bak, path)
            print(f"restored  {path}")


def main():
    if "--undo" in sys.argv:
        undo()
        return

    problems = 0
    for path, old, new in EDITS:
        short = path.replace(HOME, "~")
        if not os.path.exists(path):
            print(f"MISSING   {short}  (skipped)")
            problems += 1
            continue
        with open(path, encoding="utf-8", newline="") as f:
            text = f.read()
        if "\r\n" in text:  # keep Windows line endings if the file has them
            old = old.replace("\n", "\r\n")
            new = new.replace("\n", "\r\n")
        if new in text:
            print(f"ok        {short}  (already patched)")
            continue
        count = text.count(old)
        if count == 0:
            print(f"NOT FOUND {short}\n          expected: {old}")
            problems += 1
            continue
        bak = path + ".hyprlang.bak"
        if not os.path.exists(bak):
            shutil.copy2(path, bak)
        text = text.replace(old, new)
        with open(path, "w", encoding="utf-8", newline="") as f:
            f.write(text)
        print(f"patched   {short}  ({count}x)")

    if problems:
        print(f"\n{problems} edit(s) not applied, see above.")
        sys.exit(1)
    print("\nAll edits applied.")


if __name__ == "__main__":
    main()
