""""""""""" vim-nerdtree-tabs """""""""""""""""""
" https://github.com/jistr/vim-nerdtree-tabs
let g:nerdtree_tabs_open_on_console_startup=0
" map <Leader>nt <plug>NERDTreeTabsToggle<Bar>wincmd p<Bar>NERDTreeTabsFind<CR>
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_smart_startup_focus=2
let g:NERDTreeIgnore = ['\.pyc$']

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

""""""" Nerdtree """""""""""""""""""
"open if vim open with no file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTreeTabsToggle | endif
"close if only nerdwindow left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" map <Leader>nt :NERDTreeToggle<CR>
map <Leader>nt <plug>NERDTreeTabsToggle<CR>

