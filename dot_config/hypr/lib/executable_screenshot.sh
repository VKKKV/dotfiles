#!/usr/bin/env bash

USAGE() {
cat <<"USAGE"

Usage: $(basename "$0") [option]
Options:
    p     Print all outputs
    s     Select area or window to screenshot
    sf    Select area or window with frozen screen
    m     Screenshot focused monitor
    sc    Use tesseract to scan image, then add to clipboard
    sq    Scan QR code

USAGE
}

# Create secure temporary file
temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)

if [ -z "$XDG_PICTURES_DIR" ]; then
	XDG_PICTURES_DIR="$HOME/Pictures"
fi

confDir="${confDir:-$XDG_CONFIG_HOME}"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
annotation_args=("-o" "${save_dir}/${save_file}" "-f" "${temp_screenshot}")

mkdir -p "$save_dir"

annotation_tool="satty"
annotation_args+=("--copy-command" "wl-copy")

# screenshot function, globbing was difficult to read and maintain
take_screenshot() {
	local mode=$1
	shift
	local extra_args=("$@")

	# execute grimblast with given args
	if "$HOME/.config/hypr/lib/grimblast" "${extra_args[@]}" copysave "$mode" "$temp_screenshot"; then
		if ! "${annotation_tool}" "${annotation_args[@]}"; then
			notify-send -a "Screenshot Error" "Failed to open annotation tool"
			return 1
		fi
	else
		notify-send -a "Screenshot Error" "Failed to take screenshot"
		return 1
	fi
}

case $1 in
p) # print all outputs
	take_screenshot "screen"
	;;
s) # drag to manually snip an area / click on a window to print it
	take_screenshot "area"
	;;
sf) # frozen screen, drag to manually snip an area / click on a window to print it
	take_screenshot "area" "--freeze" "--cursor"
	;;
m) # print focused monitor
	take_screenshot "output"
	;;
sc) #? 󱉶 Use 'tesseract' to scan image then add to clipboard need tesseract installed
	if ! GEOM=$(slurp); then
		notify-send -a "OCR preview: Invalid geometry" -e -i "dialog-error"
		exit 1
	fi
	grim -g "${GEOM}" "${temp_screenshot}"
    magick "${temp_screenshot}" -sigmoidal-contrast 10,50% "${temp_screenshot}"
	tesseract --psm 6 --oem 3 "${temp_screenshot}" - | wl-copy
	notify-send -a "OCR preview" -i "${temp_screenshot}" -e
	rm -f "${temp_screenshot}"
	;;
sq) # 󱉶 Scan QR code need zbar installed
    if ! GEOM=$(slurp); then
        notify-send -a "QR preview: Invalid geometry" -e -i "dialog-error"
        exit 1
	fi
	grim -g "${GEOM}" "${temp_screenshot}"
    magick "${temp_screenshot}" -sigmoidal-contrast 10,50% "${temp_screenshot}"
    qr_output=$(zbarimg -q --raw --oneshot "${temp_screenshot}" 2>/dev/null | sed 's/\n$//')
    printf "%s" "$qr_output" | wl-copy
    notify-send -r 9 -a "QR Scan" "QR: successfully recognized" -i "$image_path" -e -r 9
    ;;
*) # invalid option
	USAGE
	;;
esac

[ -f "$temp_screenshot" ] && rm "$temp_screenshot"

if [ -f "${save_dir}/${save_file}" ]; then
	notify-send -a -i "${save_dir}/${save_file}" "saved in ${save_dir}"
fi

