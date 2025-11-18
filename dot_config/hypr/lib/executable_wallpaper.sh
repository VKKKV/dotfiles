#!/bin/bash
# Changes the wallpaper

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
RESIZE_TYPE="crop"

export AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-144}"    # 过渡帧率
export AWWW_TRANSITION_STEP="${AWWW_TRANSITION_STEP:-64}"     # 过渡步长
export AWWW_TRANSITION="${AWWW_TRANSITION:-any}"           # 过渡效果

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-list.cache"
CACHE_TTL=3600

check_dependencies() {
    if ! command -v awww &> /dev/null; then
        echo "cant find awww" >&2
        exit 1
    fi
}

get_wallpaper_list() {
    # check cache
    if [[ -f "$CACHE_FILE" && $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]]; then
        mapfile -t image_files < "$CACHE_FILE"
        return 0
    fi

    while IFS= read -r -d '' file; do
        image_files+=("$file")
    done < <(find "$WALLPAPER_DIR" \( -iname "*.jpg" -o -iname "*.jpeg" \
              -o -iname "*.png" -o -iname "*.webp" \) -type f -print0 2>/dev/null)

    # update cache
    if [[ ${#image_files[@]} -gt 0 ]]; then
        printf '%s\n' "${image_files[@]}" > "$CACHE_FILE"
    fi
}

main() {
    check_dependencies

    declare -a image_files
    get_wallpaper_list

    if [[ ${#image_files[@]} -eq 0 ]]; then
        echo "cant find wallpaper" >&2
        exit 1
    fi

    random_index=$(( RANDOM % ${#image_files[@]} ))
    selected_image="${image_files[$random_index]}"

    awww img --resize="$RESIZE_TYPE" "$selected_image"

    notify-send -i "$selected_image" "changed wallpaper" 2>/dev/null || true
}

main

