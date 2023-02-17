local function register(use)
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

end

return {
  register = register
}
