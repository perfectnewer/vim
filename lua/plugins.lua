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

  --- colors
  use 'ashfinal/vim-colors-violet'
  use 'overcache/NeoSolarized'
  use "savq/melange"

  use 'godlygeek/tabular'  -- line up text

  use {'Vimjas/vim-python-pep8-indent', ft='python'}

  require("pl_nvim_tree").register(use)

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
      {'kdheepak/lazygit.nvim'},
      { "nvim-telescope/telescope-live-grep-args.nvim" },
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
      tele.load_extension("live_grep_args")
    end,
  }

  use {
    'rcarriga/nvim-notify',
    requires = {'nvim-treesitter/playground'},
    config = function()
      vim.notify = require('notify')
    end,
  }

  -- Tree-sitter is a parser generator tool and an incremental parsing
  -- library.

  use "mfussenegger/nvim-dap"
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      {'theHamsta/nvim-dap-virtual-text'},
    },
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require("nvim-dap-virtual-text").setup({})
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

  require("pl_lsp").register(use)

  use {
    'jbyuki/venn.nvim',
    config = function()
      -- venn.nvim: enable or disable keymappings
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
    end,
  }

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


  if packer_bootstrap then
    require('packer').sync()
  end
end
)
