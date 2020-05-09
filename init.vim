" https://vimawesome.com/
set nu
set mouse=a
set termguicolors
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

let s:path = expand('<sfile>:p:h')
exec 'source ' .s:path. '/plugins.cfg.vim'
exec 'source ' .s:path. '/nerdtree.cfg.vim'
exec 'source ' .s:path. '/fzf.cfg.vim'
exec 'source ' .s:path. '/python.cfg.vim'
exec 'source ' .s:path. '/markdown-preview.cfg.vim'
exec 'source ' .s:path. '/coc.cfg.vim'
exec 'source ' .s:path. '/misc.cfg.vim'
