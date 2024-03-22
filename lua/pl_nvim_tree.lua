module = {}

function module.register(use)
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      local function open_nvim_tree(data)

        -- buffer is a real file on the disk
        local real_file = vim.fn.filereadable(data.file) == 1

        -- buffer is a [No Name]
        local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

        -- only files please
        if not real_file and not no_name then
          return
        end

        -- open the tree but don't focus it
        require("nvim-tree.api").tree.toggle({ focus = false })
      end
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
      -- vim.g.loaded_netrw = 1
      -- vim.g.loaded_netrwPlugin = 1
      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true
      -- OR setup with some options
      require("nvim-tree").setup({
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
    tag = 'v1.1' -- optional, updated every week. (see issue #1193)
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
