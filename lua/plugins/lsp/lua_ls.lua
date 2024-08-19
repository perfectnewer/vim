local M = {}
function M.setup()
  return {
    settings = { Lua = {} },
    on_init = function(client)
      local join = vim.fs.joinpath
      if client.workspace_folders ~= nil then
        local path = client.workspace_folders[1].name
        -- Don't do anything if there is project local config
        if vim.uv.fs_stat(join(path, '.luarc.json'))
            or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
        then
          return
        end
      end

      -- Apply neovim specific settings
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, join('lua', '?.lua'))
      table.insert(runtime_path, join('lua', '?', 'init.lua'))

      local nvim_settings = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT',
          path = runtime_path
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' }
        },
        workspace = {
          checkThirdParty = false,
          library = {
            -- Make the server aware of Neovim runtime files
            vim.env.VIMRUNTIME,
            vim.fn.stdpath('config'),
            '${3rd}/luv/library'
          },
        },
      }

      client.config.settings.Lua = vim.tbl_deep_extend(
        'force',
        client.config.settings.Lua,
        nvim_settings
      )
    end,
  }
end

return M
