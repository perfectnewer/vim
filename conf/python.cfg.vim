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

let s:pyenv_py2_prefix = system('pyenv prefix neovim2')
if s:pyenv_py2_prefix[-1:] == "\n"
	let s:pyenv_py2_prefix = s:pyenv_py2_prefix[:-2]
endif

let s:pyenv_py3_prefix = system('pyenv prefix neovim3')
if s:pyenv_py3_prefix[-1:] == "\n"
	let s:pyenv_py3_prefix = s:pyenv_py3_prefix[:-2]
endif
let g:python_host_prog = s:pyenv_py2_prefix . '/bin/python'
let g:python3_host_prog = s:pyenv_py3_prefix . '/bin/python'
"python with virtualenv support
if $PYENV_VIRTUAL_ENV != ""
	let s:path = expand('<sfile>:p:h')
	let s:v=system('python -c "import sys; print(sys.version_info.major)"')
	if s:v == 2 && has('python')
		exec 'source ' .s:path. '/python2_venv'
	elseif s:v == 3 && has('python3')
		exec 'source ' .s:path. '/python3_venv'
	endif
endif
