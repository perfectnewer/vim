return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    { "rcarriga/nvim-dap-ui" },
  },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    require('go').setup({
      -- other setups ....
      lsp_cfg = {
        capabilities = capabilities,
        -- other setups
      },
    })
  end,
  -- event = { "CmdlineEnter *.go|*.gomod" },  -- event or filetype
  ft = { "go", 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  enable = true,
}
