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
filetype plugin indent on
syntax enable
" set background=light
colorscheme solarized

" set backupdir=~/.vim/.bak
" set directory=~/.vim/.bak

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行
autocmd FileType python,java,sh,vim,markdown,go
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4

autocmd BufRead *.js,*.html,*.rb
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2
autocmd BufRead *.thrift,*.c,*.cc,*.cpp,*.sql
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4
autocmd BufNewFile
    \ *.py
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ call append(0, "#!/usr/bin/env python") |
    \ call append(1, "# coding: utf-8")


let c_space_errors=1
"" autoformat
let g:formatter_yapf_style = 'pep8'

" "python with virtualenv support
" if has('python')
" python << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   execfile(activate_this, dict(__file__=activate_this))
" EOF
" elseif has('python3')
" python3 << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   with open(activate_this, 'r') as f:
"     exec(f.read(), dict(__file__=activate_this))
" EOF
" endif

"key mappings
"""""""""""""""""""""""""""""""""""""""""""""""
imap jk <ESC>
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

vmap <silent> * :call VisualSelection('f')<CR>
vmap <silent> # :call VisualSelection('b')<CR>
map <space> za
map <leader>tn :tabnew
map <leader>tb :tabnext <cr>
map <leader>tp :tabprevious <cr>
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nnoremap <space> za

" map <leader>cp :cd %:p:h<cr>:pwd<cr>
" map <leader>ag :Ag! 
" map <leader>af :AgFile! 

autocmd FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>

"""""""""""" ycm """"""""""""""""""""
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>


""""""" Nerdtree """""""""""""""""""
"open if vim open with no file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"close if only nerdwindow left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <Leader>nt :NERDTreeToggle<CR>

"""""""" indentLine """"""""""""""""
let g:intdentline_char = '|'

" let g:SimpylFold_docstring_preview=1
" markdown preview
let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
nmap <silent> <F8> <Plug>MarkdownPreview        " 普通模式


"""""" plugins """"""""""

" Plugin 'Valloric/ListToggle'

" Bundle 'altercation/vim-colors-solarized'
" Bundle 'scrooloose/nerdtree'
" Bundle 'kien/ctrlp.vim'
" Bundle 'rking/ag.vim'
" Bundle 'Raimondi/delimitMate'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'tmhedberg/SimpylFold'
" Plugin 'vim-scripts/indentpython.vim'
" Plugin 'tpope/vim-fugitive'
" Plugin 'Yggdroot/indentLine'
" Plugin 'fatih/vim-go'

"track the engine.
" Plugin 'scrooloose/syntastic'
"Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
" Plugin 'honza/vim-snippets'
" 
" Bundle "git://github.com/MarcWeber/vim-addon-mw-utils.git"
" Bundle "git://github.com/tomtom/tlib_vim.git"
" 
" Bundle 'ianva/vim-youdao-translater'
" Bundle 'kevinw/pyflakes-vim'
" Bundle 'terryma/vim-multiple-cursors'
" Bundle 'hdima/python-syntax'
" Bundle 'tpope/vim-surround'
" Bundle 'tpope/vim-repeat'
" Bundle 'ntpeters/vim-better-whitespace'
" Bundle 'bronson/vim-trailing-whitespace'
" Bundle 'scrooloose/nerdcommenter'
" Bundle 'Lokaltog/vim-powerline'
" Bundle 'majutsushi/tagbar'
"括号显示增强
" Bundle 'kien/rainbow_parentheses.vim'
" Bundle 'Emmet.vim'
" Bundle 'mattn/webapi-vim'
" Bundle 'mattn/gist-vim'
" Bundle 'AutoComplPop'
" Bundle 'taglist.vim'
" Bundle 'Vim-Support'
" Bundle 'winmanager--Fox'
" call vundle#end()            " required
