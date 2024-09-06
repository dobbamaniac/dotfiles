#!/bin/bash

# Check if the current window matches the conditions

WINDOW_CLASS=$(xdotool getwindowfocus getwindowclassname)
WINDOW_TITLE=$(xdotool getwindowfocus getwindowname)

if [[ "$WINDOW_CLASS" == "kitty" && "$WINDOW_TITLE" == "scratchpad" ]]; then
    i3-msg move scratchpad
else
    i3-msg kill
fi
