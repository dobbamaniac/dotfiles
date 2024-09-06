#!/bin/sh

CURRENT_TTY=$(tty)

case "$CURRENT_TTY" in
    /dev/tty1)
        echo "Logged in from TTY1"
        if [[ "$(xrandr | awk '/HDMI2/ {print $2}')" == "connected" ]]; then
		xrandr --output eDP1 --auto --primary --output HDMI2 --auto --left-of eDP1
	else
		xrandr --output eDP1 --auto --primary --output HDMI2 --off
	fi
	wpg -m
	echo 255 > /sys/devices/pci0000:00/0000:00:1f.4/i2c-6/6-002c/rmi4-00/rmi4-00.fn03/serio2/sensitivity
	xinput --set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 0.15
	xinput --set-prop "Synaptics TM3276-022" "libinput Accel Speed" 0.45
	exec i3 --config ~/.config/i3/config
        ;;
    /dev/tty2)
        echo "Logged in from TTY2"
        if [[ "$(xrandr | awk '/HDMI2/ {print $2}')" == "connected" ]]; then
		xrandr --output eDP1 --auto --primary --output HDMI2 --auto --left-of eDP1
	else
		xrandr --output eDP1 --auto --primary --output HDMI2 --off
	fi
	wpg -m
	echo 255 > /sys/devices/pci0000:00/0000:00:1f.4/i2c-6/6-002c/rmi4-00/rmi4-00.fn03/serio2/sensitivity
	xinput --set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 0.15
	xinput --set-prop "Synaptics TM3276-022" "libinput Accel Speed" 0.45
	exec i3 --config ~/.config/i3/config2
        ;;
    /dev/tty3)
        ;;
    *)
        ;;
esac

