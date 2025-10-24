let g:tcomment_opleader1 = '<Space>c'

" typst
" g:typst_syntax_highlight: Enable syntax highlighting. Default: 1
" g:typst_cmd: Specifies the location of the Typst executable. Default: 'typst'
let g:typst_pdf_viewer = 'zathura'
" g:typst_conceal: Enable concealment. Default: 0
" g:typst_conceal_math: Enable concealment for math symbols in math mode (i.e. replaces symbols with their actual unicode character). OBS: this can affect performance, see issue #64. Default: g:typst_conceal
" g:typst_conceal_emoji: Enable concealing emojis, e.g. #emoji.alien becomes 👽. Default: g:typst_conceal
" g:typst_auto_close_toc: Specifies whether TOC will be automatically closed after using it. Default: 0
" g:typst_auto_open_quickfix: Specifies whether the quickfix list should automatically open when there are errors from typst. Default: 1
" g:typst_embedded_languages: A list of languages that will be highlighted in code blocks. Typst is always highlighted. If language name is different from the syntax file name, you can use renaming, e.g. 'rs -> rust' (spaces around the arrow are mandatory). Default: []
" g:typst_folding: Enable folding for typst heading Default: 0
" g:typst_foldnested: Enable nested foldings Default: 1

let maplocalleader = ","
let g:mkdp_refresh_slow = 1
let g:mkdp_command_for_global = 1
let g:mkdp_open_to_the_world = 1
let g:mkdp_browser = 'zen-browser'
let g:mkdp_theme = 'dark'
function OpenMarkdownPreview (url)
      execute "silent ! zen-browser --new-window " . a:url
endfunction
let g:mkdp_browserfunc = 'OpenMarkdownPreview'

let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeAutoDeleteBuffer=1
let NERDTreeConfirmDelete='yes'
let NERDTreeConfirmRename='yes'

let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline_section_z = "%3p%% %l:%c"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' ℅:'

