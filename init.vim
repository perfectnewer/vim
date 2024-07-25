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

vim.g.is_unix = vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1

local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end

-- load('user.settings')
-- load('user.commands')
-- load('user.keymaps')
require('user.plugins')

--    {
--      'nvimdev/lspsaga.nvim',
--      branch = 'main',
--      dependencies = {
--        -- { 'neovim/nvim-lspconfig', tag = 'v0.1.8' },
--        { 'ms-jpq/coq_nvim',      branch = 'coq' },
--        { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
--        { 'ms-jpq/coq.thirdparty', branch = '3p' },
--      },
--      config = function()
--        -- for coq
--        vim.g.coq_settings = {
--          auto_start = true,
--          clients = {
--            lsp = {
--              resolve_timeout = 0.2,
--              weight_adjust = 1,
--            },
--          },
--          display = {
--            icons = {
--              mode = 'none'
--            }
--          },
--          keymap = {
--            jump_to_mark = 'c-n'
--          }
--        }
--
--        vim.lsp.set_log_level('debug')
--        local opts = { noremap = true, silent = true }
--        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
--        -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--        -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
--        local saga = require('lspsaga')
--        saga.setup({
--          -- your configuration
--        })
--
--        vim.keymap.set('n', '<Leader>ot', '<cmd>Lspsaga open_floaterm zsh<CR>', { silent = true })
--        vim.keymap.set('t', '<Leader>ot', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })
--
--        vim.keymap.set('n', '<Leader>ol', '<cmd>Lspsaga outline <CR>', { silent = true })
--        vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
--        vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
--
--        -- Use an on_attach function to only map the following keys
--        -- after the language server attaches to the current buffer
--        local on_attach = function(client, bufnr)
--          require('navigator.lspclient.mapping').setup({client=client, bufnr=bufnr}) -- setup navigator keymaps here,
--          require("navigator.dochighlight").documentHighlight(bufnr)
--          require('navigator.codeAction').code_action_prompt(bufnr)
--
--          -- Enable completion triggered by <c-x><c-o>
--          vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format({async = false})]]
--          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--          -- Mappings.
--          -- See `:help vim.lsp.*` for documentation on any of the below functions
--          local bufopts = { noremap = true, silent = true, buffer = bufnr }
--          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
--          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--          vim.keymap.set('n', 'gt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', bufopts)
--          vim.keymap.set('n', 'gs', '<cmd>split | lua vim.lsp.buf.definition()<CR>', bufopts)
--          vim.keymap.set('n', 'ge', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
--          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--
--          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
--          vim.keymap.set('n', 'Ks', '<Cmd>Lspsaga signature_help<CR>', bufopts)
--          -- Rename
--          vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', bufopts)
--          -- Definition preview
--          vim.keymap.set('n', 'Kd', '<cmd>Lspsaga preview_definition<CR>', bufopts)
--
--          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--          -- vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, bufopts)
--          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
--          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
--          vim.keymap.set('n', '<space>wl', function()
--            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--          end, bufopts)
--          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
--          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
--          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
--          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
--          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
--        end
--
--        local lsp_flags = {
--          -- This is the default in Nvim 0.7+
--          debounce_text_changes = 150,
--        }
--        require 'lspconfig'.solargraph.setup {
--          on_attach = on_attach,
--          flags = lsp_flags,
--        }
--        require 'lspconfig'.tsserver.setup {
--          on_attach = on_attach,
--          flags = lsp_flags,
--        }
--        require 'lspconfig'.gopls.setup {
--          on_attach = on_attach,
--          flags = lsp_flags,
--        }
--        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
--
--        require('lspconfig').lua_ls.setup({
--          on_attach = on_attach,
--          flags = lsp_flags,
--          capabilities = lsp_capabilities,
--          settings = {
--            Lua = {
--              runtime = {
--                version = 'LuaJIT'
--              },
--              diagnostics = {
--                -- Get the language server to recognize the `vim` global
--                globals = { 'vim' },
--              },
--              workspace = {
--                library = {
--                  vim.env.VIMRUNTIME,
--                }
--                -- Make the server aware of Neovim runtime files
--                -- library = vim.api.nvim_get_runtime_file('', true),
--              }
--            }
--          }
--        })
--
--        local util = require('lspconfig/util')
--        local path = util.path
--        local function get_python_path(workspace)
--          -- Use activated virtualenv.
--          if vim.env.VIRTUAL_ENV then
--            return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
--          end
--
--          -- Find and use virtualenv from pipenv in workspace directory.
--          local match = vim.fn.glob(path.join(workspace, 'Pipfile'))
--          if match ~= '' then
--            local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
--            return path.join(venv, 'bin', 'python')
--          end
--
--          -- Fallback to system Python.
--          return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
--        end
--
--        -- only show above warnings
--        local capabilities = vim.lsp.protocol.make_client_capabilities()
--        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
--        local pyrightpath = vim.fn.system({"pyenv", "prefix", "neovim3"})
--        local pyrightcmd = {pyrightpath:gsub("\n", "") .. "/bin/pyright-langserver", "--stdio"}
--        require 'lspconfig'.pyright.setup(require('coq').lsp_ensure_capabilities({
--          capabilities = capabilities,
--          on_attach = on_attach,
--          flags = lsp_flags,
--          on_init = function(client)
--            client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
--          end,
--          cmd = pyrightcmd,
--        }))
--
--        require('lspconfig')['rust_analyzer'].setup({
--          on_attach = on_attach,
--          flags = lsp_flags,
--          -- Server-specific settings...
--          settings = {
--            ['rust-analyzer'] = {}
--          }
--        })
--
--        vim.cmd('COQnow')
--      end,
--      ft = { 'python', 'lua', 'go' },
--    },
--
--
--    {
--      "ray-x/go.nvim",
--      dependencies = {  -- optional packages
--        "ray-x/guihua.lua",
--        "neovim/nvim-lspconfig",
--        "nvim-treesitter/nvim-treesitter",
--        {"rcarriga/nvim-dap-ui"},
--      },
--      config = function()
--        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--        require('go').setup({
--          -- other setups ....
--          lsp_cfg = {
--            capabilities = capabilities,
--            -- other setups
--          },
--        })
--        require('dap').set_log_level('TRACE')
--      end,
--      event = {"CmdlineEnter"},
--      ft = {"go", 'gomod'},
--      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
--    },

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
