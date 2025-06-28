let g:tcomment_opleader1 = '<Space>c'

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

let g:floaterm_shell = 'bash'
let g:floaterm_title = 'floaterm ($1|$2)'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
let g:floaterm_position = 'center'
let g:floaterm_opener = 'edit'
let g:floaterm_autoclose = 2
let g:floaterm_autohide = v:true
let g:floaterm_autoinsert = v:false
let g:floaterm_rootmarkers   = ['.git']
highlight link FloatermBorder Visual

autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

