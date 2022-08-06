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
vim.notify = require("notify")

local saga = require 'lspsaga'

-- change the lsp symbol kind
-- local kind = require('lspsaga.lspkind')
-- kind[type_number][2] = icon -- see lua/lspsaga/lspkind.lua

-- use default config
saga.init_lsp_saga({
})

require("nvim-tree").setup({
  open_on_setup = true,
  sync_root_with_cwd = true,
  view = {
    adaptive_size = false,
    width = 32,
    mappings = {
      list = {
        { key = "t", action = "tabnew" },
        { key = "E", action = "vsplit" },
        { key = "s", action = "split" },
        { key = "C-h", action = "" },
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

lua << EOF
vim.g.coq_settings = {
  auto_start = true,
  clients = {
    lsp = {
      resolve_timeout = 0.2,
      weight_adjust = 1,
    },
  },
  display = {
    icons = {
      mode =  'none'
    }
  },
  keymap = {
    jump_to_mark = 'c-n'
  }
}

EOF

lua << EOF
  local actions = require('telescope.actions')
  local tele = require('telescope')
  tele.setup({
    defaults = {
    },
    pickers = {
      find_files = {
      }
    },
    extensions = {
      -- ...
    },
  })
  tele.load_extension('fzf')
EOF
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>tl <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>tg <cmd>Telescope git_files<cr>
nnoremap <silent> <leader>tb <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>tt <cmd>Telescope help_tags<cr>

lua << EOF
require'nvim-treesitter.configs'.setup({
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
    -- 启用增量选择
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "toml",
    "json",
    "yaml",
    "python",
    "rust",
    "go",
    "html"
  },
})
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.wo.foldlevel = 1
EOF

nnoremap <leader>ss <cmd>lua require('spectre').open()<CR>
"search current word
nnoremap <leader>sc <cmd>lua require('spectre').open_visual({select_word=true})<CR>
vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
"  search in current file
nnoremap <leader>sp viw:lua require('spectre').open_file_search()<cr>
" run command :Spectre
