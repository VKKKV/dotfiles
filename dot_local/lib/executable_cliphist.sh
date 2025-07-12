#!/usr/bin/env bash

# define paths and files
del_mode=false

# process clipboard selections for multi-select mode
process_selections() {
    if [ true != "${del_mode}" ]; then
        # Read the entire input into an array
        mapfile -t lines #! Not POSIX compliant
        # Get the total number of lines
        total_lines=${#lines[@]}

        # handle special commands
        if [[ "${lines[0]}" = ":d:e:l:e:t:e:"* ]]; then
            "${0}" --delete
            return
        elif [[ "${lines[0]}" = ":w:i:p:e:"* ]]; then
            "${0}" --wipe
            return
        elif [[ "${lines[0]}" = ":b:a:r:"* ]] || [[ "${lines[0]}" = *":c:o:p:y:"* ]]; then
            "${0}" --copy
            return
        elif [[ "${lines[0]}" = ":f:a:v:"* ]]; then
            "${0}" --favorites
            return
        elif [[ "${lines[0]}" = ":o:p:t:"* ]]; then
            "${0}"
            return
        fi

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
    else
        # handle delete mode
        while IFS= read -r line; do
            if [[ "${line}" = ":w:i:p:e:"* ]]; then
                "${0}" --wipe
                break
            elif [[ "${line}" = ":b:a:r:"* ]]; then
                "${0}" --delete
                break
            elif [ -n "$line" ]; then
                cliphist delete <<<"${line}"
                notify-send "Deleted" "${line}"
            fi
        done
        exit 0
    fi
}

# check if content is binary and handle accordingly
check_content() {
    local line
    read -r line
    if [[ ${line} == *"[[ binary data"* ]]; then
        cliphist decode <<<"$line" | wl-copy
        local img_idx
        img_idx=$(awk -F '\t' '{print $1}' <<<"$line")
        local temp_preview="${HYDE_RUNTIME_DIR}/pastebin-preview_${img_idx}"
        wl-paste >"${temp_preview}"
        notify-send -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
        return 1
    fi
}

run_rofi() {
    rofi -dmenu -config "$HOME/.config/rofi/themes/clipboard.rasi" "$@"
}

# display clipboard history and copy selected item
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

