" format
" install astyle clang dart elixir go texlive-core perl-tidy python-autopep8 python-black python-ruff python-sqlparse rubocop rustfmt shfmt
Plug 'vim-autoformat/vim-autoformat'
" whichkey
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" copilot
Plug 'github/copilot.vim'
" language packs
Plug 'sheerun/vim-polyglot'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" use % jump
Plug 'andymass/matchup.vim'
" auto disable search highlight
Plug 'romainl/vim-cool'
" discord rpc
Plug 'Stoozy/vimcord'
Plug 'christoomey/vim-tmux-navigator'
" cursor move smoothly
Plug 'psliwka/vim-smoothie'
Plug 'tpope/vim-surround'
"snippets
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'
" latex
Plug 'lervag/vimtex'
" img paste
Plug 'ferrine/md-img-paste.vim'
" cP cV
Plug 'christoomey/vim-system-copy'
" MarkdownPreview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
" leader+cc & leader+cv
Plug 'preservim/nerdcommenter'
" THEME
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" vue
Plug 'posva/vim-vue'
" nerdtree
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'PhilRunninger/nerdtree-visual-selection', { 'on': 'NERDTreeToggle' }

" coc
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" coc vim
Plug 'yaegassy/coc-volar', { 'do': 'yarn install --frozen-lockfile' }
Plug 'yaegassy/coc-volar-tools', { 'do': 'yarn install --frozen-lockfile' }

