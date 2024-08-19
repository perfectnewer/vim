return {
  'jbyuki/venn.nvim',
  config = function()
    function _G.Toggle_venn()
      local venn_enabled = vim.b.venn_enabled
      if venn_enabled == 'nil' then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        require('user.keymaps').venn(true)
      else
        vim.cmd([[setlocal ve=]])
        require('user.keymaps').venn(false)
        vim.b.venn_enabled = nil
      end
    end
  end,
  keys = {
    { '<LEADER>v', Toggle_venn, desc = "Venn ascii draw" },
  },
}
