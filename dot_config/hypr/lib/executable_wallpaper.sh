#!/bin/bash
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

# See awww-img(1)
RESIZE_TYPE="crop"
export AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-144}"
export AWWW_TRANSITION_STEP="${AWWW_TRANSITION_STEP:-2}"
export AWWW_TRANSITION="${AWWW_TRANSITION:-grow}"

find "$HOME/Pictures/Wallpapers" -type f \
    | while read -r img; do
        echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
    done \
    | sort -n | cut -d':' -f2- \
    | while read -r img; do
        awww img --resize="$RESIZE_TYPE" "$img"
    done

