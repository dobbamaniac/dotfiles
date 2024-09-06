#!/usr/bin/env bash

case "$1" in
	"workspaces")
		echo "show workspaces" > /tmp/bar_listener_pipe
		;;
	"nowplaying")
		echo "show nowplaying" > /tmp/bar_listener_pipe
		;;
	"usage")
		echo "show usage" > /tmp/bar_listener_pipe
		;;
	"status")
		echo "show status" > /tmp/bar_listener_pipe
		;;
	*)
		echo "No matching bar"
		;;
esac
