" ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" latex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let maplocalleader = ","

" MarkdownPreview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_command_for_global = 1
let g:mkdp_open_to_the_world = 1
let g:mkdp_browser = 'zen-browser'
let g:mkdp_theme = 'dark'

" nerdcommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
" let g:NERDAltDelims_java = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
" nerdtree visual
" show hidden file
let NERDTreeShowHidden=1
" dont quit tree while open file
let NERDTreeQuitOnOpen=0
" while delete file
let NERDTreeAutoDeleteBuffer=1
" option confirm
let NERDTreeConfirmDelete='yes'
let NERDTreeConfirmRename='yes'

" themes
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline_section_z = "%3p%% %l:%c"
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}   " 兼容非 Powerline 字体
endif
let g:airline_symbols.colnr = ' ℅:' " 简洁列号显示

" coc
let g:coc_node_path='/usr/bin/node'
let g:coc_global_extensions = [
\'coc-marketplace',
\'coc-ltex',
\'coc-cl',
\'coc-json',
\'coc-toml',
\'coc-tsserver',
\'coc-git',
\'coc-sumneko-lua',
\'coc-pairs',
\'coc-snippets']

" coc_pairs
autocmd FileType tex let b:coc_pairs = [["$", "$"]]

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" copilot
autocmd VimEnter * Copilot disable

