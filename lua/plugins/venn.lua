return {
  'jbyuki/venn.nvim',
  config = function()
    -- venn.nvim: enable or disable keymappings
    function _G.Toggle_venn()
      local venn_enabled = vim.inspect(vim.b.venn_enabled)
      if venn_enabled == 'nil' then
        vim.b.venn_enabled = true
        vim.cmd([[setlocal ve=all]])
        require('user.keymaps').venn(true)
      else
        vim.cmd([[setlocal ve=]])
        vim.cmd([[mapclear <buffer>]])
        require('user.keymaps').venn(false)
        vim.b.venn_enabled = nil
      end
    end
  end,
  keys = {
    { '<LEADER>v', '<CMD>lua Toggle_venn()<CR>', desc = "Venn ascii draw" },
  },
}
