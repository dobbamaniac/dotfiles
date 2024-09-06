#!/bin/bash

MODE_FILE="/home/rneal/.config/i3/scripts/.mode.txt"

MODE=$(cat "$MODE_FILE")

case "$MODE" in
	"default")
		echo ""
		;;	
	"resize")
		echo "󰘕"
		;;
	"[l]ogout  [r]eboot  [s]hutdown")
		echo ""
		;;
	*)
		echo "i3 mode not recognized"
esac


