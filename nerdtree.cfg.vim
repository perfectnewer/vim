""""""" Nerdtree """""""""""""""""""
"open if vim open with no file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"close if only nerdwindow left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" map <Leader>nt :NERDTreeToggle<CR>

""""""""""" vim-nerdtree-tabs """""""""""""""""""
" https://github.com/jistr/vim-nerdtree-tabs
let g:nerdtree_tabs_open_on_console_startup=0
map <Leader>nt :NERDTreeTabsToggle<CR>

""""""""""" nerdtree-git-plugin """"""""""""""""""
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
