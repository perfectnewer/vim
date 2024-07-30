local Plugin = {
  'ray-x/starry.nvim',
  config = function()
    local style = "Mariana" -- "earlysummer"
    local config = {
      style = {
        name = style,
      },
    }
    require('starry').setup(config)
    vim.g.colorscheme = style
    vim.g.starry_italic_comments = true
  end,
  lazy = false,
}

return Plugin
