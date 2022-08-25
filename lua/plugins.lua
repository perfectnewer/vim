-- https://vimawesome.com/   vim plugins site

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap.set(mode, lhs, rhs, options)
end

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'ashfinal/vim-colors-violet'
  use 'godlygeek/tabular'  -- line up text

  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append 'eol:↴'
      -- vim.opt.listchars:append 'space:⋅'
      require('indent_blankline').setup({
          space_char_blankline = ' ',
          show_current_context = true,
          show_current_context_start = false,
          show_trailing_blankline_indent = false, 
          show_end_of_line = true,
      })
    end,
    ft = {'python', 'go', 'lua'}
  })

  use {'Vimjas/vim-python-pep8-indent', ft='python'}

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      require('nvim-tree').setup({
        open_on_setup = true,
        sync_root_with_cwd = true,
        view = {
          adaptive_size = false,
          width = 32,
          mappings = {
            list = {
              { key = 't', action = 'tabnew' },
              { key = 'E', action = 'vsplit' },
              { key = 's', action = 'split' },
              { key = 'C-h', action = '' },
            },
          },
        },
        renderer = {
          icons = {
            webdev_colors = true,
            git_placement = 'before',
            padding = ' ',
            symlink_arrow = ' ➛ ',
            show = {
              file = true,
              folder = false,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = '',
              symlink = '',
              folder = {
                arrow_closed = '',
                arrow_open = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
                symlink_open = '',
              },
            },
          },
        },
      })
    end,
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
      {'kdheepak/lazygit.nvim'},
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
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = 'smart_case',        -- or 'ignore_case' or 'respect_case'
                                             -- the default case_mode is 'smart_case'
          }
        },
      })
      tele.load_extension('fzf')
      tele.load_extension('lazygit')
    end,
  }

  use {
    'rcarriga/nvim-notify',
    requires = {'nvim-treesitter/playground'},
    config = function()
      vim.notify = require('notify')
    end,
  }

  use {
    'ms-jpq/coq_nvim', branch = 'coq',
    requires = {
      {'ms-jpq/coq.artifacts', branch = 'artifacts'},
      {'ms-jpq/coq.thirdparty', branch = '3p'},
    },
    config = function()
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
            mode =  'none'
          }
        },
        keymap = {
          jump_to_mark = 'c-n'
        }
      }
    end,
    ft = {'python', 'lua', 'go'}
  }

  -- Tree-sitter is a parser generator tool and an incremental parsing
  -- library.
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
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
            'python',
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
          'lua'
        },
      })
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
      -- 默认不要折叠
      -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
      vim.wo.foldlevel = 1
    end,
  }

  -- A search panel for neovim.
  -- Spectre find the enemy and replace them with dark power.
  use {
    'windwp/nvim-spectre',
    requires = {
      {'nvim-lua/plenary.nvim'},
    }
  }

  use 'neovim/nvim-lspconfig'

  use({
    'glepnir/lspsaga.nvim',
    branch = 'main',
    requires = {
      'neovim/nvim-lspconfig',
      {'ms-jpq/coq_nvim', branch = 'coq'},
      {'ms-jpq/coq.artifacts', branch = 'artifacts'},
    },
    config = function()
      -- vim.lsp.set_log_level('debug')
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      local saga = require('lspsaga')
      saga.init_lsp_saga({
          -- your configuration
      })

      vim.keymap.set("n", "<Leader>ot", "<cmd>Lspsaga open_floaterm zsh<CR>", { silent = true })
      vim.keymap.set("t", "<Leader>ot", "<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>", { silent = true })

      vim.keymap.set('n', '<Leader>ol', ':LSoutlineToggle <CR>', {silent = true})
      vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
      vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
      local action = require('lspsaga.action')
      -- Only jump to error
      vim.keymap.set('n', '[E', function()
        require('lspsaga.diagnostic').goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, { silent = true })
      vim.keymap.set('n', ']E', function()
        require('lspsaga.diagnostic').goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, { silent = true })

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
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
      require'lspconfig'.solargraph.setup{
          on_attach = on_attach,
          flags = lsp_flags,
      }
      require'lspconfig'.tsserver.setup{
          on_attach = on_attach,
          flags = lsp_flags,
      }
      require'lspconfig'.gopls.setup{
          on_attach = on_attach,
          flags = lsp_flags,
      }

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

      require'lspconfig'.pyright.setup(require('coq').lsp_ensure_capabilities({
          on_attach = on_attach,
          flags = lsp_flags,
          on_init = function(client)
              client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
          end,
        })
      )
      require('lspconfig')['rust_analyzer'].setup{
          on_attach = on_attach,
          flags = lsp_flags,
          -- Server-specific settings...
          settings = {
            ['rust-analyzer'] = {}
          }
      }

      require'lspconfig'.sumneko_lua.setup(require('coq').lsp_ensure_capabilities({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
        cmd = {
          vim.fn.stdpath('config')..'/lua-language-server/bin/lua-language-server'
        }
      }))
      vim.cmd('COQnow')
    end,
    ft = {'python', 'lua', 'go'},
  })

  use {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup()
      map('n', '<Leader>ol', ':SymbolsOutline <CR>', {silent = true})
    end,
    disable = true
  }

  use {
  -- View and search LSP symbols, tags in Vim/NeoVim
    'liuchengxu/vista.vim',
    config = function()
      map('n', '<Leader>ol', ':Vista <CR>', {silent = true})
    end,
    disable = true
  }

  use {
    'tanvirtin/vgit.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config =  function()
      vim.o.updatetime = 300
      vim.o.incsearch = false
      vim.wo.signcolumn = 'yes'
      require('vgit').setup()
    end
  }

  use {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function ()
      require('mini.pairs').setup()
    end
  }

  use 'jbyuki/venn.nvim'
  use {
    'kdheepak/lazygit.nvim',
    -- config = function()
    --  map('n', '<Leader>lg', '<cmd>LazyGit<CR>', { silent = true })
    -- end
  }

  use {
    'ray-x/go.nvim',
    requires = {'ray-x/guihua.lua'},
  }

  use {
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  }

  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'Shougo/neosnippet.vim'
  use 'Shougo/neosnippet-snippets'

  if packer_bootstrap then
    require('packer').sync()
  end
end
)
