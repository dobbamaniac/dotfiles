#!/usr/bin/env bash
EXISTING_SCRATCHPAD=$(wmctrl -l | awk '{print $4}' | grep -x "scratchpad")

if [ -n "$EXISTING_SCRATCHPAD" ]; then
	i3-msg scratchpad show
	echo "scratchpad already exists!"
else
	kitty -T scratchpad &
	
	while ! wmctrl -l | awk '{print $4}' | grep -x "scratchpad" > /dev/null; do
        	sleep 0.1
    	done

	i3-msg scratchpad show
	echo "scratchpad didn't exist, created new one."
fi 
