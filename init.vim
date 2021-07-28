" https://vimawesome.com/

set nu
set termguicolors

let $NVIM_COC_LOG_LEVEL = 'debug'
let s:curdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" let s:path = expand('<sfile>:p:h')
" exec 'source ' .s:path. '/plugins.cfg.vim'
" load config
exec 'source ' .s:curdir. '/plugins.cfg.vim'
exec 'source ' .s:curdir. '/misc.cfg.vim'
for fpath in split(globpath(expand(s:curdir.'/conf'), '*.vim'), '\n')
  exec 'source' . fnameescape(fpath)
endfor
