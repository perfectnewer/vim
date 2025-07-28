local _M = {}

local mapset = function(mode, lhs, rhs, desc)
  local opts = { noremap = true, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opts)
end

_M.telescope = function()
  mapset("n", "<C-p>", "<cmd>Telescope find_files<cr>", "Telescope find_files")
  -- mapset("<silent> <leader>tl", "<cmd>Telescope live_grep<cr>", "Telescope live_grep")
  mapset("n", "<silent> <leader>tl", require("telescope").extensions.live_grep_args.live_grep_args, "Telescope live_grep")
  mapset("n", "<silent> <leader>tg", "<cmd>Telescope git_files<cr>", "git_files")
  mapset("n", "<silent> <leader>tb", "<cmd>Telescope buffers<cr>", "Telescope buffers")
  mapset("n", "<silent> <leader>tt", "<cmd>Telescope help_tags<cr>", "help_tags")
end

_M.common = function()
  mapset("n", "<leader><space>", -- Toggle all folds
    function()
      local get_opt = vim.api.nvim_win_get_option
      local set_opt = vim.api.nvim_win_set_option

      if get_opt(0, "foldlevel") >= 0 then
        vim.cmd("normal za")
      else
        vim.cmd("normal }")
      end
    end,
    "toggle fold"
  )
  mapset("i", "jk", "<ESC>", "")
  mapset("n", "<C-j>", "<C-W>j", "")
  mapset("n", "<C-k>", "<C-W>k", "")
  mapset("n", "<C-h>", "<C-W>h", "")
  mapset("n", "<C-l>", "<C-W>l", "")

  mapset("v", "<silent> *", "<cmd>call VisualSelection('f')<CR>", "")
  mapset("v", "<silent> #", "<cmd>call VisualSelection('b')<CR>", "")
  mapset("n", "<leader>tn", "<cmd>tabnew", "tab new")
  mapset("n", "<leader>tj", "<cmd>tabnext <cr>", "tabnext")
  mapset("n", "<leader>tk", "<cmd>tabprevious <cr>", "tabp")
  mapset("n", "<leader>te", "<cmd>tabedit <c-r>=expand('%:p:h')<cr>/", "tab edit")
  mapset("n", "<leader>tc", "<cmd>tabclose <cr>", "tab close")
  mapset("n", "<leader>tt", "<cmd>tabnew term://zsh <cr> i", "tabterm")
end

_M.venn = function(enable)
  if enable then
    -- draw a line on HJKL keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
    -- draw a box by pressing "f" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
  else
    vim.api.nvim_buf_del_keymap(0, "n", "J")
    vim.api.nvim_buf_del_keymap(0, "n", "K")
    vim.api.nvim_buf_del_keymap(0, "n", "L")
    vim.api.nvim_buf_del_keymap(0, "n", "H")
    vim.api.nvim_buf_del_keymap(0, "v", "f")
  end
end

_M.lspsaga = function()
  -- vim.keymap.set('n', '<Leader>ot', '<cmd>Lspsaga term_toggle<CR>', { silent = true })
  -- vim.keymap.set('t', '<Leader>ot', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })
end

_M.enable = false

return _M
