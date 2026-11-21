#!/bin/bash

pkill -f "reddragon_conf.kbd" 2>/dev/null

/usr/bin/kmonad "/home/pulkit/.config/kmonad/reddragon_conf.kbd" &
