#!/usr/bin/env bash

del_mode=false
process_selections() {
    # Read the entire input into an array
    mapfile -t lines #! Not POSIX compliant
    # Get the total number of lines
    total_lines=${#lines[@]}

    # process regular clipboard items
    local output=""
    # Iterate over each line in the array
    for ((i = 0; i < total_lines; i++)); do
        local line="${lines[$i]}"
        local decoded_line
        decoded_line="$(echo -e "$line\t" | cliphist decode)"
        if [ $i -lt $((total_lines - 1)) ]; then
            printf -v output '%s%s\n' "$output" "$decoded_line"
        else
            printf -v output '%s%s' "$output" "$decoded_line"
        fi
    done
    echo -n "$output"
}

# check if content is binary and handle accordingly
check_content() {
    local line
    read -r line
    if [[ ${line} == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        local img_idx
        img_idx=$(awk -F '\t' '{print $1}' <<<"$line")
        local temp_preview="~/pastebin-preview_${img_idx}"
        wl-paste >"${temp_preview}"
        notify-send -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
        return 1
    fi
}

run_rofi() {
    rofi -dmenu -config "~/.config/rofi/themes/clipboard.rasi" "$@"
}

show_history() {
    local selected_item
    selected_item=$( (
        cliphist list
    ) | run_rofi -i -display-columns 2 -selected-row 1)

    [ -n "${selected_item}" ] || exit 0

    if echo -e "${selected_item}" | check_content; then
        process_selections <<<"${selected_item}" | wl-copy
        paste_string "${@}"
        echo -e "${selected_item}\t" | cliphist delete
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

