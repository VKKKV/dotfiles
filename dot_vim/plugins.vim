call plug#begin()
Plug 'christoomey/vim-system-copy'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kaarmu/typst.vim'
Plug 'PhilRunninger/nerdtree-visual-selection', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'yaegassy/coc-volar', { 'do': 'yarn install --frozen-lockfile' }
Plug 'yaegassy/coc-volar-tools', { 'do': 'yarn install --frozen-lockfile' }
Plug 'honza/vim-snippets'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'github/copilot.vim'
" Plug 'Exafunction/windsurf.vim'
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
                  \'@yaegassy/coc-intelephense',
                  \'coc-lists',
                  \'coc-markdownlint',
                  \'coc-word',
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
