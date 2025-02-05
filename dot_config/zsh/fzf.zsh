#!/usr/bin/zsh
# fzf setting
# modify from https://github.com/chinanf-boy/
# Define the patterns to exclude
EXCLUDES=(
	'IdeaProjects-main/'
	'node_modules/'
	'build/'
	'gems/'
	'.icons/'
	'google-chrome/'
)
# Construct the fd command with exclusions
FD_COMMAND="fd --hidden"
for EXCLUDE in "${EXCLUDES[@]}"; do
	FD_COMMAND+=" --exclude '$EXCLUDE'"
done
export FZF_DEFAULT_COMMAND="$FD_COMMAND"
export FZF_DEFAULT_OPTS='--bind=ctrl-j:preview-down,ctrl-k:preview-up --preview "[[ $(file --mime -b {}) =~ ^image ]] && fzf-preview.sh {} || [[ $(file --mime {}) =~ binary ]] || ( bat --color=always --style=plain.changes --line-range=:500 {}) 2> /dev/null | head -500"'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
