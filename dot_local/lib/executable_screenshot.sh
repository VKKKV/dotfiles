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

USAGE
}

SCREENSHOT_POST_COMMAND+=(
)

SCREENSHOT_PRE_COMMAND+=(
)

pre_cmd() {
	for cmd in "${SCREENSHOT_PRE_COMMAND[@]}"; do
		eval "$cmd"
	done
	trap 'post_cmd' EXIT
}

post_cmd() {
	for cmd in "${SCREENSHOT_POST_COMMAND[@]}"; do
		eval "$cmd"
	done
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

# Add any additional annotation arguments
[[ -n "${SCREENSHOT_ANNOTATION_ARGS[*]}" ]] && annotation_args+=("${SCREENSHOT_ANNOTATION_ARGS[@]}")

# screenshot function, globbing was difficult to read and maintain
take_screenshot() {
	local mode=$1
	shift
	local extra_args=("$@")

	# execute grimblast with given args
	if "$HOME/.local/lib/grimblast" "${extra_args[@]}" copysave "$mode" "$temp_screenshot"; then
		if ! "${annotation_tool}" "${annotation_args[@]}"; then
			notify-send -a "HyDE Alert" "Screenshot Error" "Failed to open annotation tool"
			return 1
		fi
	else
		# notify-send -a "HyDE Alert" "Screenshot Error" "Failed to take screenshot"
		return 1
	fi
}

pre_cmd

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
sc) #? 󱉶 Use 'tesseract' to scan image then add to clipboard
	check_package tesseract-data-eng tesseract
	if ! GEOM=$(slurp); then
		notify-send -a "HyDE Alert" "OCR preview: Invalid geometry" -e -i "dialog-error"
		exit 1
	fi
	grim -g "${GEOM}" "${temp_screenshot}"
	pkg_installed imagemagick && magick "${temp_screenshot}" -sigmoidal-contrast 10,50% "${temp_screenshot}"
	tesseract "${temp_screenshot}" - | wl-copy
	notify-send -a "HyDE Alert" "OCR preview" -i "${temp_screenshot}" -e
	rm -f "${temp_screenshot}"
	;;
*) # invalid option
	USAGE
	;;
esac

[ -f "$temp_screenshot" ] && rm "$temp_screenshot"

if [ -f "${save_dir}/${save_file}" ]; then
	notify-send -a "HyDE Alert" -i "${save_dir}/${save_file}" "saved in ${save_dir}"
fi
