#!/bin/bash

# Lock file path
LOCK_FILE="/tmp/scroll_move_window_throttle.lock"

# Check if the lock file exists
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create the lock file
touch "$LOCK_FILE"

# Move window based on input argument
case "$1" in
	"left")
		i3-msg move left
		;;
	"up")
		i3-msg move up
		;;
	"right")
		i3-msg move right
		;;
	"down")
		i3-msg move down
		;;
	*)
		;;
esac

# Sleep to throttle further input (adjust this value to your preference)
sleep 0.25

# Remove the lock file to allow further inputs
rm -f "$LOCK_FILE"

