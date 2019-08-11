set nu
set background=dark
colorscheme solarized

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

autocmd BufRead *.js,*.html,*.rb
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

" use tab navi through complete list
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" plugin config
let s:path = expand('<sfile>:p:h')
exec 'source ' .s:path. '/nerdtree.cfg.vim'
exec 'source ' .s:path. '/vim-javascript.vim'
exec 'source ' .s:path. '/deoplete.cfg.vim'
exec 'source ' .s:path. '/vim-go.cfg.vim'
exec 'source ' .s:path. '/ale.cfg.vim'
exec 'source ' .s:path. '/fzf.cfg.vim'
exec 'source ' .s:path. '/python.cfg.vim'

