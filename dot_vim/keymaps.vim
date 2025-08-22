let g:coc_snippet_next = '<tab>'
source "~/.config/vim/open_file_under_cursor.vim"

autocmd CursorHold * silent call CocActionAsync('highlight')

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

nmap <leader>r  <Plug>(coc-rename)
nnoremap <Leader>mp :MarkdownPreview<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fg :Rg<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>tt :FloatermToggle<CR>
tnoremap <silent> <leader>tt <C-\><C-n>:FloatermToggle<CR>
nnoremap <silent> <leader>tn :FloatermNew<CR>
nnoremap <silent> <leader>tp :FloatermPrev<CR>
nnoremap <silent> <leader>tn :FloatermNext<CR>
tnoremap <silent> <leader>tp <C-\><C-n>:FloatermPrev<CR>
tnoremap <silent> <leader>tn <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <leader>tk :FloatermKill<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>
nnoremap <silent> <Leader>d :CocDiagnostics<CR>
nnoremap <silent> <Leader>o :CocOutline<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>a <Plug>(coc-codeaction)
nmap gs <Plug>(coc-git-chunkinfo)
nmap gc <Plug>(coc-git-commit)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

autocmd FileType markdown nmap <buffer><silent> <leader>mi :call mdip#MarkdownClipboardImage()<CR>

inoremap <silent><expr> <Tab>
			\ exists('b:_copilot.suggestions') ? copilot#Accept("\<CR>") :
			\ coc#pum#visible() ? coc#pum#next(1):
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ NextCharIsPair() ? "\<Right>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <backspace> coc#pum#visible() ? "\<bs>\<c-r>=coc#start()\<CR>" : "\<bs>"

" inoremap <silent><expr> <c-space> coc#refresh()

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! NextCharIsPair() abort
	let col = col('.') - 1
	let l:next_char = getline('.')[col]
	return l:next_char =~# ')\|]\|}\|>\|''\|"\|`'
endfunction

command! -nargs=0 Format :call CocActionAsync('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

