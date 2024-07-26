-- Note: this is where you can add plugins that don't require any configuration.
-- as soon as you need to add options to a plugin consider making a dedicated file.

local Plugins = {
  { 'overcache/NeoSolarized' },
  { 'savq/melange' },
  { 'morhetz/gruvbox' },
  { 'godlygeek/tabular' }, -- line up text

  { 'SirVer/ultisnips' },
  { 'honza/vim-snippets' },
  { 'Shougo/neosnippet.vim' },
  { 'Shougo/neosnippet-snippets' },
  { 'mhinz/vim-startify' },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
    lazy = true,
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
    'rcarriga/nvim-notify',
    dependencies = { 'nvim-treesitter/playground' },
    config = function()
      vim.notify = require('notify')
    end,
    lazy = false,
  },

  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },


  -- A search panel for neovim.
  -- Spectre find the enemy and replace them with dark power.
  {
    'windwp/nvim-spectre',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'folke/trouble.nvim' },
    }
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

  {
    'nvimdev/indentmini.nvim',
    event = 'BufEnter',
    config = function()
      require('indentmini').setup()
    end,
    ft = { 'python', 'go', 'lua', 'js' }
  },

  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },

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

  { 'tpope/vim-repeat' },
}

return Plugins
