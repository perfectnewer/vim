" https://vimawesome.com/

set nu
set termguicolors
set completeopt=menu,menuone,noselect
set mouse=nvih
set laststatus=2
set statusline=%t%m%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %=%{&ff}:[%04l,%03v][%3p%%]

" set foldmethod=syntax
" set foldmethod=indent
" set foldlevelstart=1
noremap <expr> <space><space> (foldlevel(line('.'))>0) ? "za" : "}"

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行
" colorscheme monokai_pro
" colorscheme solarized
colorscheme violet
" colorscheme NeoSolarized
" let g:solarized_termcolors=256
" colorscheme solarized
let s:hour=strftime('%H')
if s:hour >= '07' && s:hour <= '18'
	set background=light
else
	set background=dark
endif
set background=dark

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml,*.json,*.md,*.vim,*.lua
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2

autocmd BufRead *.sh
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4

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
nnoremap <silent> <leader>e  :NvimTreeFocus<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>


lua << EOF
local fn = vim.fn
local install_path = fn.stdpath('config')..'/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end
EOF

lua require('plugins')

let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:cfg_files = split(globpath(expand(s:curdir.'/conf'), '*.vim'), '\n')
call sort(s:cfg_files)
for fpath in s:cfg_files
  exec 'source' . fnameescape(fpath)
endfor

let g:vista_default_executive = 'nvim_lsp'
let g:vista_executive_for = {
  \ 'cpp': 'nvim_lsp',
  \ 'php': 'nvim_lsp',
  \ 'python': 'nvim_lsp',
  \ 'lua': 'nvim_lsp',
  \ }

" lua << EOF
" 
" local saga = require 'lspsaga'
" 
" -- change the lsp symbol kind
" -- local kind = require('lspsaga.lspkind')
" -- kind[type_number][2] = icon -- see lua/lspsaga/lspkind.lua
" 
" -- use default config
" saga.init_lsp_saga({
" })
" 
" EOF
"
" semshi
" https://github.com/numirias/semshi/blob/master/README.md


nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>tl <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>tg <cmd>Telescope git_files<cr>
nnoremap <silent> <leader>tb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>tt <cmd>Telescope help_tags<cr>

nnoremap <leader>ss <cmd>lua require('spectre').open()<CR>
"search current word
nnoremap <leader>sc <cmd>lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
" run command :Spectre
