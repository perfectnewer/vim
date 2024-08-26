" python

autocmd BufNewFile
    \ *.py
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ call append(0, "#!/usr/bin/env python") |
    \ call append(1, "# coding: utf-8")

autocmd FileType python
    \ setlocal expandtab | setlocal tabstop=4 | setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ setlocal fileformat=unix | setlocal formatprg=autopep8 | setlocal colorcolumn=120 |
    \ nnoremap <LocalLeader>i :!isort %<CR><CR>

"python with virtualenv support
if $PYENV_VIRTUAL_ENV != ""
	let s:path = expand('<sfile>:p:h')
	if g:system_py_version == 2 && has('python')
		exec 'source ' .s:path. '/python2_venv'
	elseif g:system_py_version == 3 && has('python3')
		exec 'source ' .s:path. '/python3_venv'
	endif
endif
