#!/usr/bin/env bash

# Wait until wpg -m is finished
while pgrep -u $UID -x wpg > /dev/null; do sleep 0.1; done

# Terminate scripts used by modules
ps -ef | grep barlistener.py | grep -v grep | awk '{print $2}' | xargs kill
ps -ef | grep hideIt.sh | grep -v grep | awk '{print $2}' | xargs kill

# Terminate polybar instances and wait until their processes have completely ended
pgrep -u $UID -x polybar | xargs kill -9
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done 

# Launch bars
~/.config/polybar/scripts/workspacesWidth.sh default &
polybar -c ~/.config/polybar/workspaces.ini workspaces -r &
polybar -c ~/.config/polybar/nowplaying.ini nowplaying -r &
polybar -c ~/.config/polybar/usage.ini usage -r &
polybar -c ~/.config/polybar/status.ini status -r &

# Stat bar listener and hide bars
setsid python3 ~/.config/polybar/scripts/barListener.py > /dev/null 2>&1 & 
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-nowplaying_eDP1$' --region 1498x0+384+10 --direction top --peek 0 > /dev/null 2>&1 &
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-usage_eDP1$' --region 38x1080+386+-10 --direction bottom --peek 0 > /dev/null 2>&1 & 
setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-status_eDP1$' --region 1402x1080+480+-10 --direction bottom --peek 0 > /dev/null 2>&1 & 
polybar-msg -p $(ps -ef | grep polybar/workspaces | grep -v grep | awk '{print $2}') cmd hide

# Potential commands for hiding bar with systray?
#(xdo id -m -N Polybar && polybar-msg -p $(ps -ef | grep floating_sysinfo | grep -v grep | awk '{print $2}') cmd hide)  > /dev/null 2>&1 &
#STATUSFILE="$HOME/.config/polybar/scripts/.sysinfo.active"
#rm -f "$STATUSFILE"

echo "Bars launched!"


