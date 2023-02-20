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
  use "fatih/molokai"
  use "savq/melange"
  use "morhetz/gruvbox"

  use 'godlygeek/tabular'  -- line up text

  use {'Vimjas/vim-python-pep8-indent', ft='python'}

  require("pl_nvim_tree").register(use)
  require("pl_treesitter").register(use)

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
      -- vim.notify = require('notify')
    end,
  }

  -- Tree-sitter is a parser generator tool and an incremental parsing
  -- library.

  use "mfussenegger/nvim-dap"

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
  require("pl_venn").register(use)

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


  use "mhinz/vim-startify"
  if packer_bootstrap then
    require('packer').sync()
  end
end
)
