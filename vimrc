set backspace=indent,eol,start
set ruler
set incsearch
set list
set lcs=tab:>-,trail:-
set nu
set hlsearch
set mouse=a
set autoindent
set foldmethod=syntax
set foldlevel=99
set autoread
set encoding=utf-8
set completeopt=longest,menu
filetype on
filetype plugin on
syntax enable
set background=dark
colorscheme solarized

" 进入上次退出的位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

autocmd FileType python,java,sh,vim,markdown
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4

autocmd FileType go setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4

autocmd BufRead *.js,*.html,*.rb
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2
autocmd BufRead *.thrift,*.c,*.cc,*.cpp,*.sql,*.proto
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4
autocmd BufNewFile
    \ *.py
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ call append(0, "#!/usr/bin/env python") |
    \ call append(1, "# coding: utf-8")

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
map <leader>cfp :cd %:p:h<cr>:pwd<cr>

" map <leader>ag :Ag! 
" map <leader>af :AgFile! 

source ~/.vim/nerdtree-git-plugin.cfg
source ~/.vim/nerdtree.cfg
source ~/.vim/markdown-preview.cfg
" source ~/.vim/vim-go.cfg
source ~/.vim/ale.cfg
source ~/.vim/completor.cfg
source ~/.vim/python.cfg
