# export FZF_DEFAULT_COMMAND='fd --color=always --hidden --follow --exclude .git --exclude .svn --exclude .hg --exclude node_modules --exclude vendor --exclude __pycache__ --exclude .cache --exclude .idea --exclude .vscode --exclude .DS_Store --exclude *.log'
export FZF_DEFAULT_COMMAND='fd --hidden'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export FZF_DEFAULT_OPTS='--preview "[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500"'

