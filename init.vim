" https://vimawesome.com/

set nu
set termguicolors
set completeopt=menu,menuone,noselect
set mouse=nvih
set laststatus=2
set statusline=%t%m%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %=%{&ff}:[%04l,%03v][%3p%%]
set clipboard+=unnamedplus

" set foldmethod=syntax
" set foldmethod=indent
" set foldlevelstart=1
noremap <expr> <space><space> (foldlevel(line('.'))>0) ? "za" : "}"

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd BufRead *.js,*.html,*.rb,*.yaml,*.yml,*.json,*.md,*.vim,*.lua
    \ setlocal expandtab | setlocal tabstop=2 |
    \ setlocal softtabstop=2 | setlocal shiftwidth=2

autocmd BufRead *.sh
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4

autocmd BufRead *.go setlocal tabstop=4 | setlocal softtabstop=0 noexpandtab shiftwidth=4
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
" nnoremap <silent> <leader>ft :NvimTreeToggle<CR>
" nnoremap <silent> <leader>ff :NvimTreeFindFile<CR>
nnoremap <silent> <F9> :TagbarToggle<CR>

"--
"- Resources:
"- * Learn lua in X minutes
"- https://learnxinyminutes.com/docs/lua/
"-
"- * Lua crash course (12 min video)
"- https://www.youtube.com/watch?v=NneB6GX1Els
"-
"- * Neovim's official lua guide
"- https://neovim.io/doc/user/lua-guide.html
"-
"- * Lazy.nvim: plugin configuration
"- https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi
"--

lua << EOF

-- Colors are applied automatically based on user-defined highlight groups.
-- There is no default value.
vim.cmd.highlight('IndentLine guifg=#123456')
-- Current indent line highlight
vim.cmd.highlight('IndentLineCurrent guifg=#123456')

vim.g.is_unix = vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1

local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end

-- load('user.settings')
-- load('user.commands')
-- load('user.keymaps')
require('user.plugins')

EOF


let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:cfg_files = split(globpath(expand(s:curdir.'/conf'), '*.vim'), '\n')
call sort(s:cfg_files)
for fpath in s:cfg_files
  exec 'source' . fnameescape(fpath)
endfor

" colorscheme monokai_pro
" colorscheme violet
" colorscheme dawnfox
" colorscheme nightfox

set termguicolors
" colorscheme NeoSolarized
" colorscheme melange
" colorscheme molokai
" colorscheme gruvbox
colorscheme mariana

let s:hour=strftime('%H')
if s:hour >= '07' && s:hour <= '17'
	set background=light
else
	set background=dark
endif

let g:vista_default_executive = 'nvim_lsp'
let g:vista_executive_for = {
  \ 'cpp': 'nvim_lsp',
  \ 'php': 'nvim_lsp',
  \ 'python': 'nvim_lsp',
  \ 'lua': 'nvim_lsp',
  \ }

"
" semshi
" https://github.com/numirias/semshi/blob/master/README.md


nnoremap <C-p> <cmd>Telescope find_files<cr>
" nnoremap <silent> <leader>tl <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>tl <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>
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

lua << EOF

function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true})
EOF
