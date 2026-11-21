#!/bin/bash

while true; do
    if [ -e /dev/input/by-id/usb-Evision_RGB_Keyboard-event-kbd ]; then
        pgrep -f "reddragon_conf.kbd" >/dev/null || \
            kmonad ~/.config/kmonad/reddragon_conf.kbd &
    fi

    sleep 2
done
