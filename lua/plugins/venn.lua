local M = {
  'jbyuki/venn.nvim',
  config = function()
    -- function _G.Toggle_venn()
    --   local venn_enabled = vim.b.venn_enabled
    --   if venn_enabled == 'nil' then
    --     vim.b.venn_enabled = true
    --     vim.cmd([[setlocal ve=all]])
    --     require('user.keymaps').venn(true)
    --   else
    --     vim.cmd([[setlocal ve=]])
    --     require('user.keymaps').venn(false)
    --     vim.b.venn_enabled = nil
    --   end
    -- end
  end,
  name = "venn.nvim",
  keys = {
    -- { '<LEADER>ve', Toggle_venn, desc = "Venn ascii draw" },
  },
}

M.init = function()
  M.venn_hydra()
end

local venn_hint_utf = [[
 Arrow^^^^^^  Select region with <C-v>^^^^^^
 ^ ^ _K_ ^ ^  _f_: Surround with box ^ ^ ^ ^
 _H_ ^ ^ _L_  _<C-h>_: ◄, _<C-j>_: ▼
 ^ ^ _J_ ^ ^  _<C-k>_: ▲, _<C-l>_: ► _<C-c>_
]]

-- :setlocal ve=all
-- :setlocal ve=none
M.venn_hydra = function()
  local ok_hydra, Hydra = pcall(require, 'hydra')
  if not ok_hydra then
    vim.notify('hydra not installed...', vim.log.ERROR)
    return
  end

  Hydra({
    name = 'Draw Utf-8 Venn Diagram',
    hint = venn_hint_utf,
    config = {
      color = 'pink',
      invoke_on_body = true,
      on_enter = function()
        require("lazy").load({ plugins = "venn.nvim", wait = true })
        vim.wo.virtualedit = 'all'
      end,
      on_exit = function()
        vim.wo.virtualedit = nil
      end
    },
    mode = 'n',
    body = '<leader>ve',
    heads = {
      { '<C-h>', 'xi<C-v>u25c4<Esc>' }, -- mode = 'v' somehow breaks
      { '<C-j>', 'xi<C-v>u25bc<Esc>' },
      { '<C-k>', 'xi<C-v>u25b2<Esc>' },
      { '<C-l>', 'xi<C-v>u25ba<Esc>' },
      { 'H',     '<C-v>h:VBox<CR>' },
      { 'J',     '<C-v>j:VBox<CR>' },
      { 'K',     '<C-v>k:VBox<CR>' },
      { 'L',     '<C-v>l:VBox<CR>' },
      { 'f',     ':VBox<CR>',        { mode = 'v' } },
      { '<C-c>', nil,                { exit = true } },
    },
  })
end

return M
