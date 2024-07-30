return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    { 'theHamsta/nvim-dap-virtual-text' },
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
  enable       = true,
  -- version      = nil,
  build        = ':TSUpdate',
  config       = function()
    require('nvim-dap-virtual-text').setup({})
    require 'nvim-treesitter.configs'.setup({
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
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
        enable = true,
        disable = {
          -- 'python',
        },
      },
      -- :help nvim-treesitter-textobjects-modules
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          }
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
        'markdown',
      },
    })
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- 默认不要折叠
    -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
    vim.wo.foldlevel = 2
  end,
  ft           = { 'python', 'go', 'lua', 'js', 'bash', 'vim' }
}
