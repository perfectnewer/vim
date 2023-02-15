module = {}

function module.register(use)
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      -- vim.g.loaded_netrw = 1
      -- vim.g.loaded_netrwPlugin = 1
      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true
      -- OR setup with some options
      require("nvim-tree").setup({
        open_on_setup = true,
        sync_root_with_cwd = true,
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
          width = 32,
          mappings = {
            list = {
              { key = "u", action = "dir_up" },
              { key = 't', action = 'tabnew' },
              { key = 'E', action = 'vsplit' },
              { key = 's', action = 'split' },
              { key = 'C-h', action = '' },
            },
          },
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- use {
  --   config = function()
  --     require('nvim-tree').setup({
  --       renderer = {
  --         icons = {
  --           webdev_colors = true,
  --           git_placement = 'before',
  --           padding = ' ',
  --           symlink_arrow = ' ➛ ',
  --           show = {
  --             file = true,
  --             folder = false,
  --             folder_arrow = true,
  --             git = true,
  --           },
  --           glyphs = {
  --             default = '',
  --             symlink = '',
  --             folder = {
  --               arrow_closed = '',
  --               arrow_open = '',
  --               default = '',
  --               open = '',
  --               empty = '',
  --               empty_open = '',
  --               symlink = '',
  --               symlink_open = '',
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  --   ft = {"---"},
  -- }
end

return module
