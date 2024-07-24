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


" lua << EOF
" local fn = vim.fn
" local install_path = fn.stdpath('config')..'/pack/packer/start/packer.nvim'
" if fn.empty(fn.glob(install_path)) > 0 then
"   print("start install packer in ", install_path)
"   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
"   print("clone result ", packer_bootstrap)
"   vim.cmd [[packadd packer.nvim]]
" end
" require('plugins')
" EOF
lua << EOF
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  vim.fn.system({ "brew", "install", "fd" })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
-- https://lazy.folke.io/spec/examples
require('lazy').setup({
  opts = { open_cmd = "noswapfile vnew" },
  spec = {
    { 'overcache/NeoSolarized' },
    { 'savq/melange' },
    { 'morhetz/gruvbox' },
    {
      'ray-x/starry.nvim',
      config = function()
        local config = {
          style = {
            name = 'mariana',
          },
        }
        require('starry').setup(config)
      end,
    },

    { 'godlygeek/tabular' }, -- line up text

    {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
      dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        { 'kdheepak/lazygit.nvim' },
        { 'nvim-telescope/telescope-live-grep-args.nvim' },
        { 'BurntSushi/ripgrep',
          build = function()
            local job = vim.fn.jobstart(
              {'brew', 'install', 'ripgrep'}
            )
          end,
        },
      },
      config = function()
        local actions = require('telescope.actions')
        local tele = require('telescope')
        tele.setup({
          defaults = {
          },
          pickers = {
            find_files = {
            }
          },
          extensions = {
            -- ...
            fzf = {
              fuzzy = true,                   -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true,    -- override the file sorter
              case_mode = 'smart_case',       -- or 'ignore_case' or 'respect_case'
              -- the default case_mode is 'smart_case'
            }
          },
        })
        tele.load_extension('fzf')
        tele.load_extension('lazygit')
        tele.load_extension('live_grep_args')
      end,
    },

    {
      'rcarriga/nvim-notify',
      dependencies = { 'nvim-treesitter/playground' },
      config = function()
        vim.notify = require('notify')
      end,
      lazy = false,
    },

    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },

    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },

    -- A search panel for neovim.
    -- Spectre find the enemy and replace them with dark power.
    {
      'windwp/nvim-spectre',
      dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'folke/trouble.nvim' },
      }
    },

    {
      'hedyhli/outline.nvim',
      lazy = true,
      cmd = { 'Outline', 'OutlineOpen' },
      keys = { -- Example mapping to toggle outline
        { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
      },
      opts = {
        -- Your setup opts here
      },
      config = function()
        -- Example mapping to toggle outline
        vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>',
          { desc = 'Toggle Outline' })

        require('outline').setup {
          -- Your setup opts here (leave empty to use defaults)
        }
      end,
    },

    -- {
    --   -- View and search LSP symbols, tags in Vim/NeoVim
    --   'liuchengxu/vista.vim',
    --   keys = {
    --     {'<Leader>ol', '<cmd>Vista <cr>', desc = 'vista', mode = 'n'},
    --   },
    -- },

    {
      'tanvirtin/vgit.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        vim.o.updatetime = 300
        vim.o.incsearch = false
        vim.wo.signcolumn = 'yes'
        require('vgit').setup()
      end
    },

    {
      'echasnovski/mini.nvim',
      branch = 'stable',
      config = function()
        require('mini.pairs').setup()
      end
    },

    { 'SirVer/ultisnips' },
    { 'honza/vim-snippets' },
    { 'Shougo/neosnippet.vim' },
    { 'Shougo/neosnippet-snippets' },

    {
      'nvimdev/indentmini.nvim',
      event = 'BufEnter',
      config = function()
          require('indentmini').setup()
      end,
      ft = { 'python', 'go', 'lua', 'js' }
    },

    -- LSP Support
    { 'neovim/nvim-lspconfig', tag = 'v0.1.8' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },

    {
      'ray-x/navigator.lua', branch = 'neovim_0.9',
      requires = {
          { 'ray-x/guihua.lua', build = 'cd lua/fzy && make' },
          -- { 'neovim/nvim-lspconfig', tag = 'v0.1.8' },
      },
    },

    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      },
    },

    { 'folke/lsp-colors.nvim' },

    {
      'nvimdev/lspsaga.nvim',
      branch = 'main',
      dependencies = {
        -- { 'neovim/nvim-lspconfig', tag = 'v0.1.8' },
        { 'ms-jpq/coq_nvim',      branch = 'coq' },
        { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
        { 'ms-jpq/coq.thirdparty', branch = '3p' },
      },
      config = function()
        -- for coq
        vim.g.coq_settings = {
          auto_start = true,
          clients = {
            lsp = {
              resolve_timeout = 0.2,
              weight_adjust = 1,
            },
          },
          display = {
            icons = {
              mode = 'none'
            }
          },
          keymap = {
            jump_to_mark = 'c-n'
          }
        }

        vim.lsp.set_log_level('debug')
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        local saga = require('lspsaga')
        saga.setup({
          -- your configuration
        })

        vim.keymap.set('n', '<Leader>ot', '<cmd>Lspsaga open_floaterm zsh<CR>', { silent = true })
        vim.keymap.set('t', '<Leader>ot', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })

        vim.keymap.set('n', '<Leader>ol', '<cmd>Lspsaga outline <CR>', { silent = true })
        vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
        vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          require('navigator.lspclient.mapping').setup({client=client, bufnr=bufnr}) -- setup navigator keymaps here,
          require("navigator.dochighlight").documentHighlight(bufnr)
          require('navigator.codeAction').code_action_prompt(bufnr)

          -- Enable completion triggered by <c-x><c-o>
          vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format({async = false})]]
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'gt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', bufopts)
          vim.keymap.set('n', 'gs', '<cmd>split | lua vim.lsp.buf.definition()<CR>', bufopts)
          vim.keymap.set('n', 'ge', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
          vim.keymap.set('n', 'Ks', '<Cmd>Lspsaga signature_help<CR>', bufopts)
          -- Rename
          vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', bufopts)
          -- Definition preview
          vim.keymap.set('n', 'Kd', '<cmd>Lspsaga preview_definition<CR>', bufopts)

          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          -- vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
        end

        local lsp_flags = {
          -- This is the default in Nvim 0.7+
          debounce_text_changes = 150,
        }
        require 'lspconfig'.solargraph.setup {
          on_attach = on_attach,
          flags = lsp_flags,
        }
        require 'lspconfig'.tsserver.setup {
          on_attach = on_attach,
          flags = lsp_flags,
        }
        require 'lspconfig'.gopls.setup {
          on_attach = on_attach,
          flags = lsp_flags,
        }
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('lspconfig').lua_ls.setup({
          on_attach = on_attach,
          flags = lsp_flags,
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                }
                -- Make the server aware of Neovim runtime files
                -- library = vim.api.nvim_get_runtime_file('', true),
              }
            }
          }
        })

        local util = require('lspconfig/util')
        local path = util.path
        local function get_python_path(workspace)
          -- Use activated virtualenv.
          if vim.env.VIRTUAL_ENV then
            return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
          end

          -- Find and use virtualenv from pipenv in workspace directory.
          local match = vim.fn.glob(path.join(workspace, 'Pipfile'))
          if match ~= '' then
            local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
            return path.join(venv, 'bin', 'python')
          end

          -- Fallback to system Python.
          return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
        end

        -- only show above warnings
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        local pyrightpath = vim.fn.system({"pyenv", "prefix", "neovim3"})
        local pyrightcmd = {pyrightpath:gsub("\n", "") .. "/bin/pyright-langserver", "--stdio"}
        require 'lspconfig'.pyright.setup(require('coq').lsp_ensure_capabilities({
          capabilities = capabilities,
          on_attach = on_attach,
          flags = lsp_flags,
          on_init = function(client)
            client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
          end,
          cmd = pyrightcmd,
        }))

        require('lspconfig')['rust_analyzer'].setup({
          on_attach = on_attach,
          flags = lsp_flags,
          -- Server-specific settings...
          settings = {
            ['rust-analyzer'] = {}
          }
        })

        vim.cmd('COQnow')
      end,
      ft = { 'python', 'lua', 'go' },
    },

    {
      'jbyuki/venn.nvim',
      config = function()
        -- venn.nvim: enable or disable keymappings
        function _G.Toggle_venn()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == 'nil' then
                vim.b.venn_enabled = true
                vim.cmd[[setlocal ve=all]]
                -- draw a line on HJKL keystokes
                vim.api.nvim_buf_set_keymap(0, 'n', 'J', '<C-v>j:VBox<CR>', {noremap = true})
                vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<C-v>k:VBox<CR>', {noremap = true})
                vim.api.nvim_buf_set_keymap(0, 'n', 'L', '<C-v>l:VBox<CR>', {noremap = true})
                vim.api.nvim_buf_set_keymap(0, 'n', 'H', '<C-v>h:VBox<CR>', {noremap = true})
                -- draw a box by pressing 'f' with visual selection
                vim.api.nvim_buf_set_keymap(0, 'v', 'f', ':VBox<CR>', {noremap = true})
            else
                vim.cmd[[setlocal ve=]]
                vim.cmd[[mapclear <buffer>]]
                vim.b.venn_enabled = nil
            end
        end
        -- toggle keymappings for venn using <leader>v
        vim.api.nvim_set_keymap()
      end,
      keys = {
        {'<LEADER>v', '<CMD>lua Toggle_venn()<CR>', desc = "Venn ascii draw"},
      },
    },

    {
      'kdheepak/lazygit.nvim',
      -- config = function()
      --  map('n', '<Leader>lg', '<cmd>LazyGit<CR>', { silent = true })
      -- end
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter"
      }
    },

    {
      "ray-x/go.nvim",
      dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        {"rcarriga/nvim-dap-ui"},
      },
      config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
        require('go').setup({
          -- other setups ....
          lsp_cfg = {
            capabilities = capabilities,
            -- other setups
          },
        })
        require('dap').set_log_level('TRACE')
      end,
      event = {"CmdlineEnter"},
      ft = {"go", 'gomod'},
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },

    {
      'iamcco/markdown-preview.nvim',
      build = function() vim.fn['mkdp#util#install']() end,
      setup = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
      lazy = true,
    },

    { 'mhinz/vim-startify' },
    -- add your plugins here
    {
      'folke/which-key.nvim',
      -- lazy-load on a command
      -- cmd = 'VimEnter',
      -- load cmp on InsertEnter
      event = 'VeryLazy',
      -- these dependencies will only be loaded when cmp loads
      -- dependencies are always lazy-loaded unless specified otherwise
      -- dependencies = {},
      -- config = function()
      -- -- ...
      -- end,
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      -- enabled = false,
    },

    {
      'nvim-tree/nvim-tree.lua',
      dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
      keys = {
        { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' , mode = {'n', 'v', 'x'}},
      },
      -- lazy-load on a command
      -- cmd = 'VimEnter',
      -- load cmp on InsertEnter
      event = {'BufEnter'},
      config = function()
        local function open_nvim_tree(data)
          -- buffer is a real file on the disk
          local real_file = vim.fn.filereadable(data.file) == 1

          -- buffer is a [No Name]
          local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

          -- only files please
          if not real_file and not no_name then
            return
          end

          -- open the tree but don't focus it
          require('nvim-tree.api').tree.toggle({ focus = false })
        end
        vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
        -- vim.g.loaded_netrw = 1
        -- vim.g.loaded_netrwPlugin = 1
        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
        -- OR setup with some options
        local function my_on_attach(bufnr)
          local api = require 'nvim-tree.api'

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
          vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
          vim.keymap.set('n', 'E', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
        end
        require('nvim-tree').setup({
          on_attach = my_on_attach,
          sync_root_with_cwd = true,
          sort_by = 'case_sensitive',
          view = {
            adaptive_size = true,
            width = 32,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        })
      end,
      tag = 'v1.4' -- optional, updated every week. (see issue #1193)
    },

    {
      'nvim-treesitter/nvim-treesitter',
      dependencies  = {
        {'theHamsta/nvim-dap-virtual-text'},
        {
          "nvim-treesitter/playground",
          cmd = {
            "TSPlaygroundToggle",
            "TSHighlightCapturesUnderCursor",
          },
          keys = {
            { "<F2>", "<cmd>TSHighlightCapturesUnderCursor<cr>", desc = "Show highlight group under cursor" },
          },
        },
      },
      version = nil,
      build = ':TSUpdate',
      config = function()
        require('nvim-dap-virtual-text').setup({})
        require'nvim-treesitter.configs'.setup({
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
          },
            -- 启用增量选择
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<CR>',
              node_incremental = '<CR>',
              node_decremental = '<BS>',
              scope_incremental = '<TAB>',
            }
          },
          highlight = {
            enable = true,
            disable = {},
          },
          indent = {
            enable = false,
            disable = {
              -- 'python',
            },
          },
          ensure_installed = {
            'toml',
            'json',
            'yaml',
            'python',
            'rust',
            'go',
            'html',
            'lua',
            'vim',
            'vimdoc',
            'javascript',
          },
        })
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
        -- 默认不要折叠
        -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
        vim.wo.foldlevel = 1
      end,
    },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'mariana' } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
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
