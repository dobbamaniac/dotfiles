#!/usr/bin/env bash

# Input argument
I3_MODE=$1

# Path to polybar config
POLYBAR_CONFIG="$HOME/.config/polybar/workspaces.ini"

# Constants
BASE_WIDTH=38
MODE_RESIZE_WIDTH=38  #64 if displaying the mode with words
MODE_POWER_WIDTH=38  #222 if displaying the mode with words
MIN_WIDTH=1

# Get screen and workspace info
SCREEN_WIDTH=$(xdpyinfo | awk '/dimensions/{print $2}' | awk -Fx '{print $1}') 
WORKSPACE_COUNT=$(wmctrl -d | wc -l)

# Initialize NEW_WIDTH
NEW_WIDTH=0 

# Determine NEW_WIDTH based on i3 mode
case "$I3_MODE" in
	"" | "default")
		NEW_WIDTH=$((WORKSPACE_COUNT * BASE_WIDTH))
		;;
	"resize")
		NEW_WIDTH=$(((WORKSPACE_COUNT * BASE_WIDTH) + MODE_RESIZE_WIDTH))
		;;
	"[l]ogout  [r]eboot  [s]hutdown")
		NEW_WIDTH=$(((WORKSPACE_COUNT * BASE_WIDTH) + MODE_POWER_WIDTH))
		;;
	*)
		echo "Unknown mode: $I3_MODE"
		exit 1
		;;
esac

# Ensure the width stays within defined bounds
if [ $NEW_WIDTH -lt $MIN_WIDTH ]; then
	NEW_WIDTH=$MIN_WIDTH
elif [ $NEW_WIDTH -gt $SCREEN_WIDTH ]; then
	NEW_WIDTH=$SCREEN_WIDTH
fi

# Calculate the new X offset to center the bar
X_OFFSET=$(( (SCREEN_WIDTH - NEW_WIDTH) / 2 ))

# Update the Polybar config with the new width and position
sed -i "s/^width = .*/width = ${NEW_WIDTH}/" $POLYBAR_CONFIG
sed -i "s/^offset-x = .*/offset-x = ${X_OFFSET}/" $POLYBAR_CONFIG

