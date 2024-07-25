local Plugin = {
  'ray-x/starry.nvim',
  config = function()
    local config = {
      style = {
        name = 'mariana',
      },
    }
    require('starry').setup(config)
  end,
}

return Plugin
