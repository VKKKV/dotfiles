call plug#begin()
Plug 'tomtom/tcomment_vim'
Plug 'github/copilot.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'psliwka/vim-smoothie'
Plug 'tpope/vim-surround'
Plug 'ferrine/md-img-paste.vim'
Plug 'christoomey/vim-system-copy'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'PhilRunninger/nerdtree-visual-selection', { 'on': 'NERDTreeToggle' }
Plug 'romainl/vim-cool'
Plug 'voldikss/vim-floaterm'
Plug 'kaarmu/typst.vim'
Plug 'honza/vim-snippets'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'yaegassy/coc-volar', { 'do': 'yarn install --frozen-lockfile' }
Plug 'yaegassy/coc-volar-tools', { 'do': 'yarn install --frozen-lockfile' }
call plug#end()

let g:coc_node_path='/usr/bin/node'
let g:coc_global_extensions = [
                  \'coc-marketplace',
                  \'coc-dictionary',
                  \'coc-ecdict',
                  \'coc-biome',
                  \'coc-eslint',
                  \'coc-git',
                  \'coc-go',
                  \'coc-clangd',
                  \'coc-highlight',
                  \'coc-json',
                  \'coc-lists',
                  \'coc-markdownlint',
                  \'coc-mocword',
                  \'coc-pairs',
                  \'coc-sh',
                  \'coc-snippets',
                  \'coc-sumneko-lua',
                  \'coc-tag',
                  \'coc-tsserver',
                  \'coc-typos',
                  \'coc-xml',
                  \'coc-css',
                  \'coc-yaml',
                  \'coc-pyright',
                  \]
