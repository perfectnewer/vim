local lazy = {}

function lazy.check_out(out)
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

function lazy.install(path)
  if not (vim.uv or vim.loop).fs_stat(path) then
    print('Installing lazy.nvim....')
    local out = vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
    lazy.check_out(out)
    out = vim.fn.system({ "brew", "install", "fd" })
    lazy.check_out(out)
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
  defaults = {
    lazy = true,
  },
  ui = {
    border = 'rounded',
  },
  install = {
    missing = false, -- install missing plugins on startup.
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "bluloco" },
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
