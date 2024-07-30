local Plugin = {
  'ray-x/starry.nvim',
  config = function()
    local style = "mariana" -- "earlysummer"
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
