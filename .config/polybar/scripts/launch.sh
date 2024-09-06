#!/usr/bin/env bash

#ps -ef | grep hideIt.sh | grep -v grep | awk '{print $2}' | xargs kill

while pgrep -u $UID -x wpg > /dev/null; do sleep 1; done

# End all active bars
killall polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Launch bar
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar -c ~/.config/polybar/config.ini -r  &
done

# Launch bar hider
#setsid ~/.config/polybar/scripts/hideIt.sh --wait --signal --name '^polybar-bar_eDP1$' --region 0x0+1920+10 --direction top --peek 0 > /dev/null 2>&1 &


echo "Bars launched..."
