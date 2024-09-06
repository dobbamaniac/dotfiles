#!/bin/env bash

# Lock file path
LOCK_FILE="/tmp/workspaceScroll.lock"

# Check if the lock file exists
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create the lock file
touch "$LOCK_FILE"

# Switch workspace based on input argument
if [ "$1" == "next" ]; then
    i3-msg workspace next
elif [ "$1" == "prev" ]; then
    i3-msg workspace prev
fi

# Sleep to throttle further input (adjust this value to your preference)
sleep 0.25

# Remove the lock file to allow further inputs
rm -f "$LOCK_FILE"

