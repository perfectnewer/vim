local Plugin = { 'williamboman/mason.nvim' }

-- See :help mason-settings
Plugin.opts = {
  ui = { border = 'rounded' },
  log_level = vim.log.levels.ERROR,
}
Plugin.ft = { 'python', 'lua', 'go', 'bash', 'markdown', 'html', 'ts', 'js' }
Plugin.enable = true

return Plugin
