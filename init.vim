" https://vimawesome.com/

set nu
" set termguicolors

let $NVIM_COC_LOG_LEVEL = 'debug'
let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" let s:path = expand('<sfile>:p:h')
" exec 'source ' .s:path. '/plugins.cfg.vim'
" load config
exec 'source ' .s:curdir. '/plugins.cfg.vim'
exec 'source ' .s:curdir. '/misc.cfg.vim'
let s:cfg_files = split(globpath(expand(s:curdir.'/conf'), '*.vim'), '\n')
call sort(s:cfg_files)

for fpath in s:cfg_files
  exec 'source' . fnameescape(fpath)
endfor

set completeopt=menu,menuone,noselect
lua << EOF
local saga = require 'lspsaga'

-- change the lsp symbol kind
-- local kind = require('lspsaga.lspkind')
-- kind[type_number][2] = icon -- see lua/lspsaga/lspkind.lua

-- use default config
saga.init_lsp_saga({
})

require("nvim-tree").setup({
  open_on_setup = true,
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "t", action = "tabnew" },
        { key = "v", action = "vsplit" },
        { key = "E", action = "split" },
      },
    },
  },
  renderer = {
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = false,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
})
EOF
