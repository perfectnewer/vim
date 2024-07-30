" https://vimawesome.com/

set nu
set termguicolors
set completeopt=menu,menuone,noselect
set mouse=nvih
set laststatus=2
set statusline=%t%m%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}\ %=%{&ff}:[%04l,%03v][%3p%%]
set clipboard+=unnamedplus


" autocmd InsertLeave * se nocul  " 用浅色高亮当前行
" autocmd InsertEnter * se cul    " 用浅色高亮当前行

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

local pyrightpath = vim.fn.system({ "pyenv", "prefix", "neovim3" })
local pyrightcmd = pyrightpath:gsub("\n", "") .. "/bin/python"
vim.g.python3_host_prog = pyrightcmd

-- Colors are applied automatically based on user-defined highlight groups.
-- There is no default value.
vim.cmd.highlight('IndentLine guifg=#123456')
-- Current indent line highlight
vim.cmd.highlight('IndentLineCurrent guifg=#123456')

vim.g.is_unix = vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1

local load = function(mod)
  package.loaded[mod] = nil
  return require(mod)
end

-- load('user.settings')
-- load('user.commands')
load('user.keymaps').common()
require('user.plugins')

vim.opt.termguicolors = true
if ( vim.g.colorscheme ~= nil ) then
  vim.cmd.colorscheme(vim.g.colorscheme)
else
  vim.cmd.colorscheme("monokai")
end

EOF


" let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" let s:cfg_files = split(globpath(expand(s:curdir.'/conf'), '*.vim'), '\n')
" call sort(s:cfg_files)
" for fpath in s:cfg_files
"   exec 'source' . fnameescape(fpath)
" endfor

" let s:hour=strftime('%H')
" if s:hour >= '07' && s:hour <= '17'
" 	set background=light
" else
" 	set background=dark
" endif

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

