" basic
syntax enable
set ttimeoutlen=50
set timeoutlen=400
set fileformat=unix
set laststatus=2
set number
set list
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:%
" set mouse=a
set scrolloff=4
set relativenumber
set encoding=utf-8
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab
set expandtab
" zR zM zA za fold
set foldlevel=999
set foldlevelstart=999
set foldmethod=syntax
set wildmenu
set autoread
set autowrite
set smartindent
set autoindent
set incsearch
set hlsearch
set ignorecase
set colorcolumn=80
set textwidth=80
set formatoptions+=tcrq
set splitbelow
set splitright
set hidden
set nobackup
set nowritebackup
set noswapfile
set cmdheight=2
set signcolumn=yes
set shortmess+=c
set updatetime=200
set lazyredraw
set ttyfast
set cursorline
set cursorcolumn
filetype indent on
filetype plugin on

" color in tmux
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
	if (has("termguicolors"))
		set termguicolors
	endif
endif

