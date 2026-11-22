#!/usr/bin/env sh
# Lua port: `hyprctl dispatch` now takes Lua dispatchers
#   closewindow pid:N -> hl.dsp.window.close({ window = "pid:N" })
#   exec dolphin      -> hl.dsp.exec_cmd("dolphin")


# set variables

scrDir=`dirname "$(realpath "$0")"`
source $scrDir/globalcontrol.sh


# sync qt5 and qt6 colors

cp "${confDir}/qt5ct/colors.conf" "${confDir}/qt6ct/colors.conf"


# restart dolphin

a_ws=$(hyprctl -j activeworkspace | jq '.id')
dpid=$(hyprctl -j clients | jq --arg wid "$a_ws" '.[] | select(.workspace.id == ($wid | tonumber)) | select(.class == "org.kde.dolphin") | .pid')
if [ ! -z ${dpid} ] ; then
    hyprctl dispatch "hl.dsp.window.close({ window = \"pid:${dpid}\" })"
    hyprctl dispatch 'hl.dsp.exec_cmd("dolphin")' &
fi
