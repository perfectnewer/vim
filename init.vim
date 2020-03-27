" https://vimawesome.com/
set nu
set mouse=a

let s:path = expand('<sfile>:p:h')
exec 'source ' .s:path. '/plugins.cfg.vim'
exec 'source ' .s:path. '/nerdtree.cfg.vim'
exec 'source ' .s:path. '/fzf.cfg.vim'
exec 'source ' .s:path. '/python.cfg.vim'
exec 'source ' .s:path. '/markdown-preview.cfg.vim'
exec 'source ' .s:path. '/coc.cfg.vim'

" exec 'source ' .s:path. '/neomake.cfg.vim'
"
" semshi
let g:semshi#filetypes=['disable'] " python
let g:semshi#excluded_hl_groups=['local']
let g:semshi#update_delay_factor=0.0002

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev Ack Ack!

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml,*.json
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2

"key mappings
"""""""""""""""""""""""""""""""""""""""""""""""
imap jk <ESC>
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
nmap <space> za

vmap <silent> * :call VisualSelection('f')<CR>
vmap <silent> # :call VisualSelection('b')<CR>
map <leader>tn :tabnew
map <leader>tb :tabnext <cr>
map <leader>tp :tabprevious <cr>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" set background=light
set background=dark
colorscheme solarized

" vimgutter options
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_map_keys = 0

let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
