local Plugin = { 'nvim-telescope/telescope.nvim' }
Plugin.cmd = { 'Telescope' }
Plugin.branch = '0.1.x'
Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
  { 'kdheepak/lazygit.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  {
    'BurntSushi/ripgrep',
    build = function()
      local job = vim.fn.jobstart(
        { 'brew', 'install', 'ripgrep' }
      )
    end,
  },
}

Plugin.config = function()
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
end

return Plugin
