#!/usr/bin/env bash

[[ "$2" == "--debug" ]] && set -x

_seat_display=DP-1
_stream_display=HDMI-A-1

set_display_mode() {
    if [[ $1 == "do" ]]; then
        if [[ ${XDG_CURRENT_DESKTOP} == "Hyprland" ]]; then
            hyprctl keyword monitor "${_seat_display}",disable
            sleep 1
            hyprctl keyword monitor "${_stream_display}",1920x1080@60,auto,1
        fi
    elif [[ $1 == "undo" ]]; then
        if [[ ${XDG_CURRENT_DESKTOP} == "Hyprland" ]]; then
            hyprctl keyword monitor "${_seat_display}",prefered,0x0,1
            sleep 1
            hyprctl keyword monitor "${_stream_display}",disable
        fi
    fi
}

set_display_mode "$1"

