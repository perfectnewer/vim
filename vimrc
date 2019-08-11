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
" set background=dark
set background=light
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

" tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

source ~/.vim/nerdtree-git-plugin.cfg
source ~/.vim/nerdtree.cfg.vim
source ~/.vim/markdown-preview.cfg
" source ~/.vim/vim-go.cfg
source ~/.vim/ale.cfg
source ~/.vim/python.cfg

let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_log_level = 'debug'
