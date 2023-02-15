
local function register(use)
  use 'neovim/nvim-lspconfig'

  use 'folke/lsp-colors.nvim'

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
    -- ft = {'python', 'lua', 'go'}
  }
  use {'ms-jpq/coq.artifacts', branch = 'artifacts'}

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
      vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
      vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
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
    ft = {'python', 'go', 'lua', 'js'}
  })

  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'Shougo/neosnippet.vim'
  use 'Shougo/neosnippet-snippets'

end

return {
  register = register
  }
