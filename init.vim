 https://vimawesome.com/
set nu
set mouse=a
set termguicolors

let s:path = expand('<sfile>:p:h')
exec 'source ' .s:path. '/plugins.cfg.vim'
exec 'source ' .s:path. '/nerdtree.cfg.vim'
exec 'source ' .s:path. '/fzf.cfg.vim'
exec 'source ' .s:path. '/python.cfg.vim'
exec 'source ' .s:path. '/markdown-preview.cfg.vim'
exec 'source ' .s:path. '/coc.cfg.vim'

set foldmethod=indent
set foldmethod=syntax
set foldlevelstart=3
let g:SimpylFold_docstring_preview = 1

command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" exec 'source ' .s:path. '/neomake.cfg.vim'
"
" semshi
" https://github.com/numirias/semshi/blob/master/README.md
let g:semshi#filetypes=['python'] " python
let g:semshi#excluded_hl_groups=['local']
let g:semshi#update_delay_factor=0.0002
" let g:semshi#error_sign=v:false  " not support python2 which is for work

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml,*.json,*.sh
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2

autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

"key mappings
"""""""""""""""""""""""""""""""""""""""""""""""
imap jk <ESC>
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l
" noremap <expr> <Space> (foldlevel(line('.'))>0) ? "za" : "}"

vmap <silent> * :call VisualSelection('f')<CR>
vmap <silent> # :call VisualSelection('b')<CR>
nmap <leader>tn :tabnew
nmap <leader>tb :tabnext <cr>
nmap <leader>tp :tabprevious <cr>
nmap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nmap <leader>tt :tabnew term://zsh <cr> i

let s:hour=strftime('%H')
if s:hour >= '07' && s:hour <= '20'
	set background=light
else
	set background=dark
endif
" colorscheme solarized
colorscheme NeoSolarized
colorscheme violet

" Default value is "normal", Setting this option to "high" or "low" does use the
" same Solarized palette but simply shifts some values up or down in order to
" expand or compress the tonal range displayed.
let g:neosolarized_contrast = "high"

" Special characters such as trailing whitespace, tabs, newlines, when displayed
" using ":set list" can be set to one of three levels depending on your needs.
" Default value is "normal". Provide "high" and "low" options.
let g:neosolarized_visibility = "high"

" I make vertSplitBar a transparent background color. If you like the origin
" solarized vertSplitBar style more, set this value to 0.
let g:neosolarized_vertSplitBgTrans = 1

" let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'

set laststatus=2
set statusline=%t%m%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %=%{&ff}:[%04l,%03v][%3p%%]

" set list lcs=tab:\|\ 

let g:indentLine_char_list = ['|', '¦', '┆', '┊']

nnoremap <silent> <F9> :TagbarToggle<CR>
