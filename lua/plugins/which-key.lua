return {
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
}
