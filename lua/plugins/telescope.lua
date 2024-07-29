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
  { 'nvim-telescope/telescope-ui-select.nvim' },
}

Plugin.init = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('telescope-file-browser.nvim', { clear = true }),
    pattern = '*',
    callback = function()
      vim.schedule(function()
        local netrw_bufname, _
        if vim.bo[0].filetype == 'netrw' then return end
        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(bufname) == 0 then
          _, netrw_bufname = pcall(vim.fn.expand, '#:p:h')
          return
        end

        -- prevents reopening of file-browser if exiting without selecting a file
        if netrw_bufname == bufname then
          netrw_bufname = nil
          return
        else
          netrw_bufname = bufname
        end
        vim.bo[0].bufhidden = 'wipe'
        require('telescope').extensions.file_browser.file_browser({
          cwd = vim.fn.expand('%:p:h'),
        })
      end)
    end,
    once = true,
    desc = 'lazy-loaded telescope-file-browser.nvimw',
  })
end

Plugin.config = function()
  local actions = require('telescope.actions')
  local tele = require('telescope')
  tele.setup({
    defaults = {
      path_display = { 'smart' },
      layout_strategy = 'flex',
      layout_config = {
        prompt_position = 'top',
      },
    },
    pickers = {
      find_files = {
      }
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
      },
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
  tele.load_extension('ui-select')
end

return Plugin
