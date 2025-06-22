" TComment
let g:tcomment_opleader1 = '<Space>c'
" ultisnips conflict with coc tab keymap
let g:UltiSnipsExpandTrigger = "<nop>"
" latex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
" set conceallevel=1
" let g:tex_conceal='abdmg'
let maplocalleader = ","
" MarkdownPreview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_command_for_global = 1
let g:mkdp_open_to_the_world = 1
let g:mkdp_browser = 'zen-browser'
let g:mkdp_theme = 'dark'
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
  let g:airline_symbols = {}   
endif
let g:airline_symbols.colnr = ' ℅:' 
" coc
let g:coc_node_path='/usr/bin/node'
let g:coc_global_extensions = [
      \'coc-pairs',
      \'coc-ltex',
      \'coc-marketplace',
      \'coc-biome',
      \'coc-dictionary',
      \'coc-ecdict',
      \'coc-eslint',
      \'coc-git',
      \'coc-go',
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
      \'coc-yank',
      \]
" coc_pairs
autocmd FileType tex let b:coc_pairs = [["$", "$"]]
" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" copilot
" autocmd VimEnter * Copilot disable
