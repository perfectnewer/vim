return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  keys = {
    { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree', mode = { 'n', 'v', 'x' } },
  },
  -- lazy-load on a command
  -- cmd = 'VimEnter',
  -- load cmp on InsertEnter
  event = { 'BufEnter' },
  config = function()
    local function open_nvim_tree(data)
      -- buffer is a real file on the disk
      local real_file = vim.fn.filereadable(data.file) == 1

      -- buffer is a [No Name]
      local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

      -- only files please
      if not real_file and not no_name then
        return
      end

      -- open the tree but don't focus it
      require('nvim-tree.api').tree.toggle({ focus = false })
    end
    vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
    -- vim.g.loaded_netrw = 1
    -- vim.g.loaded_netrwPlugin = 1
    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
    -- OR setup with some options
    local function my_on_attach(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
      vim.keymap.set('n', 'E', api.node.open.vertical, opts('Open: Vertical Split'))
      vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
      vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
    end
    require('nvim-tree').setup({
      on_attach = my_on_attach,
      sync_root_with_cwd = true,
      sort_by = 'case_sensitive',
      view = {
        adaptive_size = true,
        width = 32,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })
  end,
  tag = 'v1.4' -- optional, updated every week. (see issue #1193)
}
