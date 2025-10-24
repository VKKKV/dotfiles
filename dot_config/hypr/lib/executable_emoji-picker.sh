#!/usr/bin/env bash

# Define paths and files
rofile="~/.config/rofi/themes/clipboard.rasi"
emoji_dir="$HOME/.config/hypr/lib"
emoji_data="${emoji_dir}/emoji.db"
cache_dir="$HOME/.cache/hypr"
recent_data="${cache_dir}/landing/show_emoji.recent"

# checks if an emoji entry is valid
is_valid_emoji() {
    local emoji_entry="$1"

    # return false if emoji is empty or unique_entries is not set
    [[ -z "${emoji_entry}" || -z "${unique_entries}" ]] && return 1

    # uses bash's pattern matching instead of echo and grep
    echo -e "${unique_entries}" | grep -Fxq "${emoji_entry}"
}

# save selected emoji to recent list, remove duplicates
save_recent() {
    is_valid_emoji "${data_emoji}" || return 0
    awk -v var="$data_emoji" 'BEGIN{print var} {print}' "${recent_data}" >temp && mv temp "${recent_data}"
    awk 'NF' "${recent_data}" | awk '!seen[$0]++' >temp && mv temp "${recent_data}"
}

# Get emoji selection from rofi
get_emoji_selection() {
        echo "${unique_entries}" | rofi -dmenu -i -config "${rofile}"
}

main() {
    # create recent data file if it doesn't exist
    if [[ ! -f "${recent_data}" ]]; then
        mkdir -p "$(dirname "${recent_data}")"
        echo " Arch linux - I use Arch, BTW" >"${recent_data}"
    fi

    # read recent and main entries
    local recent_entries main_entries
    recent_entries=$(cat "${recent_data}")
    main_entries=$(cat "${emoji_data}")

    # combine entries and remove duplicates
    combined_entries="${recent_entries}\n${main_entries}"
    unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

    # get emoji selection from rofi
    data_emoji=$(get_emoji_selection)

    # avoid copying typed text to clipboard, only copy valid emoji
    [ -z "${data_emoji}" ] && exit 0

    # extract and copy selected emoji(s)
    local sel_emoji
    sel_emoji=$(printf "%s" "${data_emoji}" | cut -d' ' -f1 | tr -d '\n\r')
    wl-copy "${sel_emoji}"
}

main "$@"
