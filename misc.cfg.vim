""" basic

set mouse=nvih
" set foldmethod=syntax
set foldmethod=indent
set foldlevelstart=1
noremap <expr> <space><space> (foldlevel(line('.'))>0) ? "za" : "}"

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml,*.json,*.sh,*.md
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2

"key mappings
"""""""""""""""""""""""""""""""""""""""""""""""
imap jk <ESC>
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

vmap <silent> * :call VisualSelection('f')<CR>
vmap <silent> # :call VisualSelection('b')<CR>
nmap <leader>tn :tabnew
nmap <leader>tj :tabnext <cr>
nmap <leader>tk :tabprevious <cr>
nmap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
nmap <leader>tc :tabclose <cr>
nmap <leader>tt :tabnew term://zsh <cr> i

set laststatus=2
set statusline=%t%m%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %=%{&ff}:[%04l,%03v][%3p%%]

" colorscheme monokai_pro
" colorscheme solarized
" colorscheme violet
colorscheme NeoSolarized
let s:hour=strftime('%H')
if s:hour >= '07' && s:hour <= '18'
	set background=light
else
	set background=dark
endif

""" basic end

let g:SimpylFold_docstring_preview = 1
command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" semshi
" https://github.com/numirias/semshi/blob/master/README.md
let g:semshi#filetypes=['python'] " python
let g:semshi#excluded_hl_groups=['local']
let g:semshi#update_delay_factor=0.0002
" let g:semshi#error_sign=v:false  " not support python2 which is for work

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

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

" set list lcs=tab:\|\ 

let g:indentLine_char_list = ['|', '¦', '┆', '┊']

""" tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>
