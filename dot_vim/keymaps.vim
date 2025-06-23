let mapleader=" "
inoremap jj <Esc>

nnoremap <leader>f  :Autoformat<CR>
" tab
nnoremap <leader>tt :tabnew<CR>
nnoremap <leader>th :tabprev<CR>
nnoremap <leader>tl :tabnext<CR>
" buffer
nnoremap <Leader>h :bp<CR>
nnoremap <Leader>l :bn<CR>
nnoremap <Leader>q :bd<CR>
nnoremap <leader>b :ls<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>i :split<CR>
nnoremap <leader>v :vsplit<CR>
" resize window
nnoremap <silent> <C-Up>    :resize -2<CR>
nnoremap <silent> <C-Down>  :resize +2<CR>
nnoremap <silent> <C-Left>  :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>
" date time
nnoremap <Leader>dt "=strftime('%Y-%m-%d %H:%M:%S')<CR>P
" markdown
nnoremap <Leader>mc {O<DOWN>```<DOWN><ESC>}i```<ESC><DOWN>O<ESC>
nnoremap <Leader>mp :MarkdownPreview<CR>
autocmd FileType markdown nmap <buffer><silent> <leader>mi :call mdip#MarkdownClipboardImage()<CR>
" keybind gf gotoFile
source "~/.config/vim/open_file_under_cursor.vim"
" fzf search
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :Rg<CR>
" NERDTreeToggle
nnoremap <Leader>n :NERDTreeToggle<CR>
" whichkey
nnoremap <silent> <Leader> :WhichKey '<Space>'<CR>
" coc
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)

" Note: the `coc-snippets` extension is required for this to work.
inoremap <silent><expr> <Tab>
			\ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
			\ coc#pum#visible() ? coc#pum#next(1):
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ NextCharIsPair() ? "\<Right>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
function! NextCharIsPair() abort
	let col = col('.') - 1
	let l:next_char = getline('.')[col]
	return l:next_char =~# ')\|]\|}\|>\|''\|"\|`'
endfunction
let g:coc_snippet_next = '<tab>'

" To make <CR> to confirm selection of selected complete item or notify coc.nvim
" to format on enter, use:
inoremap <silent><expr> <CR> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <backspace> coc#pum#visible() ? "\<bs>\<c-r>=coc#start()\<CR>" : "\<bs>"
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction
nnoremap <silent> <Leader>a :CocList marketplace<CR>
nnoremap <silent> <Leader>e :CocList extensions<CR>
nnoremap <silent> <Leader>x :CocList commands<CR>
nnoremap <silent> <Leader>d :CocDiagnostics<CR>
nnoremap <silent> <Leader>o :CocOutline<CR>
" commenter keymap Space c c
" copilot enable
nnoremap <silent> <leader>, :Copilot enable<CR>
" copilot disable
nnoremap <silent> <leader>. :Copilot disable<CR>
