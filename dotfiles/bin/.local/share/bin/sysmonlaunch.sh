#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
pkgChk=("io.missioncenter.MissionCenter" "htop" "btop" "top")

for sysMon in "${!pkgChk[@]}"; do
    [ "${sysMon}" -gt 0 ] && term=$(grep -m1 '^local term' $HOME/.config/hypr/conf/keybindings.lua | cut -d '"' -f2)
    if pkg_installed "${pkgChk[sysMon]}" ; then
        pkill -x "${pkgChk[sysMon]}" || ${term} "${pkgChk[sysMon]}" &
        break
    fi
done

