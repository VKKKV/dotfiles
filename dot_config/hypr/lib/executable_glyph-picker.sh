#!/usr/bin/env bash

rofile="$HOME/.config/rofi/themes/clipboard.rasi"
glyph_dir="$HOME/.config/hypr/lib"
glyph_data="${glyph_dir}/glyph.db"
cache_dir="$HOME/.cache/"
recent_data="${cache_dir}/landing/show_glyph.recent"

save_recent_entry() {
    local glyph_line="$1"
    (
        echo "${glyph_line}"
        cat "${recent_data}"
    ) | awk '!seen[$0]++' >temp && mv temp "${recent_data}"
}

# rofi menu, get selection
get_glyph_selection() {
        echo "${unique_entries}" | rofi -dmenu -i -config "${rofile}"
}

main() {
    # create recent data file if it doesn't exist
    if [[ ! -f "${recent_data}" ]]; then
        mkdir -p "$(dirname "${recent_data}")"
        echo -e " \tArch linux - I use Arch, BTW" >"${recent_data}"
    fi

    # read recent and main entries
    local recent_entries
    recent_entries=$(cat "${recent_data}")
    local main_entries
    main_entries=$(cat "${glyph_data}")

    # combine entries and remove duplicates
    combined_entries="${recent_entries}\n${main_entries}"
    unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

    # get glyph selection from rofi
    data_glyph=$(get_glyph_selection)


    [[ -z "${data_glyph}" ]] && exit 0

    local sel_glyph=""
    sel_glyph=$(printf "%s" "${data_glyph}" | cut -d$'\t' -f1 | xargs)

    if [[ -n "${sel_glyph}" ]]; then
        wl-copy "${sel_glyph}"
        save_recent_entry "${data_glyph}"
    fi
}

# run main function
main "$@"
