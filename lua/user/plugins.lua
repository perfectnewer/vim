local lazy = {}

function lazy.install(path)
  if not (vim.uv or vim.loop).fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
    vim.fn.system({ "brew", "install", "fd" })
    print('Done.')
  end

  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
lazy.opts = {
  ui = {
    border = 'rounded',
  },
  install = {
    missing = true, -- install missing plugins on startup.
  },
  change_detection = {
    enabled = false, -- check for config file changes
    notify = false,  -- get a notification when changes are found
  },
  open_cmd = "noswapfile vnew",
}

-- Setup lazy.nvim
-- import plugins configs from nvim/lua/plugins/ folder
-- https://lazy.folke.io/spec/examples
lazy.setup({ { import = 'plugins' } })
