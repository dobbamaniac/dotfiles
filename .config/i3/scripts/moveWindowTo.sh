#!/usr/bin/env bash

#	MoveWorkspace 1.0
#	Move application to selected workspace and move there
#	Dependencies: i3-msg
#
#	By Joris van Dijk | Jorisvandijk.com 
#	Licensed under the GNU General Public License v3.0

i3-msg move container to workspace $1; i3-msg workspace $1

