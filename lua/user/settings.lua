local _M = {}

function _M.autocmd()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "vim", "lua", "yaml", "markdown", "javascript", "html", "ruby" },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.softtabstop = 2
      vim.bo.shiftwidth = 2
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "python", "shell" },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.softtabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go", "gomod", "gowork" },
    callback = function()
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 0
    end,
  })
end

return _M
