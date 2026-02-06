#!/usr/bin/env bash

# Function to handle multiple selections and stream decoded content
process_selections() {
    local first_line=true
    while IFS= read -r line;
 do
        if [ "$first_line" = true ]; then
            first_line=false
        else
            printf "\n"
        fi
        # cliphist decode reads from stdin
        cliphist decode <<< "$line"
    done
}

# Check if content is binary and handle accordingly
check_content() {
    local line
    read -r line
    if [[ ${line} == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        local img_idx
        img_idx=$(echo "$line" | cut -f1)
        # Use /tmp for temporary image previews
        local temp_preview="/tmp/pastebin-preview_${img_idx}"
        wl-paste >"${temp_preview}"
        notify-send -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
        return 1
    fi
    return 0
}

CACHE_DIR="$HOME/.cache/cliphist/thumbs"

# Process cliphist list to add icons for rofi
add_icons() {
    mkdir -p "$CACHE_DIR"
    while IFS= read -r line; do
        if [[ $line == *"[[ binary data"* ]]; then
            local id
            id=$(echo "$line" | cut -f1)
            local icon_path="$CACHE_DIR/$id.png"

            # Generate thumbnail if it doesn't exist
            if [ ! -f "$icon_path" ]; then
                cliphist decode <<< "$line" | convert - -resize 256x256 "$icon_path" 2>/dev/null
            fi

            echo -en "$line\0icon\x1f$icon_path\n"
        else
            echo "$line"
        fi
    done
}

run_rofi() {
    # Use $HOME instead of ~ for safer expansion in scripts
    rofi -dmenu -show-icons -config "$HOME/.config/rofi/themes/clipboard.rasi" "$@"
}

paste_string() {
    # Placeholder for paste functionality.
    # If arguments are passed (e.g. from a bind), handle them here.
    # Common implementation: wtype -M ctrl -k v -m ctrl
    :
}

show_history() {
    local selected_item
    selected_item=$(cliphist list | add_icons | run_rofi -i -display-columns 2 -selected-row 1)

    [ -n "${selected_item}" ] || exit 0

    if echo "${selected_item}" | check_content; then
        process_selections <<<"${selected_item}" | wl-copy
        paste_string "${@}"

        # Delete selected item(s) to bump them (if re-added by wl-copy) or remove them
        while IFS= read -r line; do
            cliphist delete <<< "$line"
        done <<< "${selected_item}"
    else
        # binary content - handled by check_content
        paste_string "${@}"
        exit 0
    fi
}

main() {
    show_history "$@"
}

main "$@"
