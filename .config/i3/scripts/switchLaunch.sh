#!/usr/bin/env bash

CURRENT_WS=$(wmctrl -d | grep "*" | awk '{print $9}')

if [ "$CURRENT_WS" == "$1" ]; then
    $1 &
else
    i3-msg workspace "${1}"
    wmctrl -x -a "$1" || $1 &
fi
