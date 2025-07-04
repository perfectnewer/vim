local Plugin = { "jay-babu/mason-nvim-dap.nvim" }

Plugin.enable = true
Plugin.dependencies = {
  { "mfussenegger/nvim-dap" },
  { "mfussenegger/nvim-dap-python" },
  { "rcarriga/nvim-dap-ui" },
}

return Plugin
