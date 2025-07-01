" basic
syntax enable
set title
set timeoutlen=400
set fileformat=unix
set laststatus=2
set number
set list
set listchars=tab:\|·,trail:·,extends:>,precedes:<,nbsp:%
set scrolloff=4
set relativenumber
set encoding=utf-8
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab
set expandtab
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
set wrap
set breakindent
set showbreak=↪\
set formatoptions+=t
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
set cursorline
set cursorcolumn
filetype indent on
filetype plugin on
syntax on

let mapleader=" "

nnoremap <leader>s :w<CR>
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>x :bd<CR>
nnoremap <leader>S :split<CR>
nnoremap <leader>v :vsplit<CR>

nnoremap <Leader>dt "=strftime('%Y-%m-%d %H:%M:%S')<CR>P
nnoremap <Leader>mc {O<DOWN>```<DOWN><ESC>}i```<ESC><DOWN>O<ESC>
nnoremap <silent> <C-Up>    :resize -2<CR>
nnoremap <silent> <C-Down>  :resize +2<CR>
nnoremap <silent> <C-Left>  :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

if empty($TMUX) && has("termguicolors")
  set termguicolors
endif

au Filetype * :setl fo-=o fo-=r

