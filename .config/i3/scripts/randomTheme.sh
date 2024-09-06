#!/usr/bin/env bash

# Show workspaces bar
#polybar-msg -p $(ps -ef | grep polybar/workspaces | grep -v grep | awk '{print $2}') cmd show

# End all polybar and hideIt.sh instances and wait until the polybar processes are completely terminated
pgrep -u $UID -x polybar | xargs kill -9
ps -ef | grep hideIt.sh | grep -v grep | awk '{print $2}' | xargs kill
#while ps -ef | grep hideIt.sh | grep -v grep > /dev/null; do sleep 0.1; done
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.01; done

# Set random wallpaper and theme
wpg -m
while pgrep -u $UID -x 'wpg -m' > /dev/null; do sleep 0.1; done

# Restart polybars
~/.config/polybar/scripts/workspacesWidth.sh default &
polybar -c ~/.config/polybar/workspaces.ini workspaces -r &
polybar -c ~/.config/polybar/nowplaying.ini nowplaying -r &
polybar -c ~/.config/polybar/usage.ini usage -r &
polybar -c ~/.config/polybar/status.ini status -r &

# Rehide polybars
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-usage_eDP1$' --region 38x1080+386+-10 --direction bottom --peek 0 > /dev/null 2>&1 & 
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-status_eDP1$' --region 1402x1080+480+-10 --direction bottom --peek 0 > /dev/null 2>&1 & 
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-nowplaying_eDP1$' --region 1498x0+384+10 --direction top --peek 0 > /dev/null 2>&1 &
polybar-msg -p $(ps -ef | grep polybar/workspaces | grep -v grep | awk '{print $2}') cmd hide
