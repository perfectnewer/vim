local Plugin = { 'williamboman/mason.nvim' }

-- See :help mason-settings
Plugin.opts = {
  ui = { border = 'rounded' },
  log_level = vim.log.levels.ERROR,
}
Plugin.ft = { 'python', 'lua', 'go', 'bash', 'markdown' }
Plugin.enable = true

return Plugin
