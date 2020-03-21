" set clipboard^=unnamed,unnamedplus
set nu
autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml
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

" plugin config
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'altercation/vim-colors-solarized'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs', { 'on':  'NERDTreeTabsToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-master branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
" Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
" Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'

Plug 'Shougo/neco-vim' | Plug 'ncm2/ncm2' | Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-jedi' | Plug 'ncm2/ncm2-go'
Plug 'ncm2/ncm2-vim' | Plug 'ncm2/ncm2-ultisnips'

" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
" enable ncm2 for all buffers
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tell-k/vim-autopep8'
Plug 'scrooloose/nerdcommenter'

call plug#end()

" set background=light
set background=dark
colorscheme solarized

let s:path = expand('<sfile>:p:h')
exec 'source ' .s:path. '/nerdtree.cfg.vim'
exec 'source ' .s:path. '/ncm2.cfg.vim'
exec 'source ' .s:path. '/fzf.cfg.vim'
exec 'source ' .s:path. '/python.cfg.vim'
exec 'source ' .s:path. '/markdown-preview.cfg.vim'

" use tab navi through complete list
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let g:UltiSnipsExpandTrigger="<nop>"
inoremap <expr> <CR> pumvisible() ? "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<CR>"
" let g:endwise_no_mappings = 1
" let g:ulti_expand_or_jump_res = 0
" function! <SID>ExpandSnippetOrReturn()
"   let snippet = UltiSnips#ExpandSnippetOrJump()
"   if g:ulti_expand_or_jump_res > 0
"     return snippet
"   else
"     return "\<C-Y>"
"   endif
" endfunction
" imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "<Plug>delimitMateCR"

