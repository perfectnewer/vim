" Indent Python in the Google way.

autocmd FileType python setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

autocmd BufNewFile
    \ *.py
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ call append(0, "#!/usr/bin/env python") |
    \ call append(1, "# coding: utf-8")

autocmd FileType python
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ setlocal autoindent | setlocal fileformat=unix |
    \ setlocal formatprg=autopep8 | setlocal colorcolumn=120

" deoplete
let g:deoplete#sources#jedi#show_docstring=1
let g:python_host_prog = '/Users/simon/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/simon/.pyenv/versions/neovim3/bin/python'
let g:pymode_indent = 0

"python with virtualenv support
if $PYENV_VIRTUAL_ENV != ""
	let s:path = expand('<sfile>:p:h')
	let s:v=system('python -c "import sys; print(sys.version_info.major)"')
	if s:v == 2 && has('python')
		exec 'source ' .s:path. '/python2_venv.vim'
	elseif s:v == 3 && has('python3')
		exec 'source ' .s:path. '/python3_venv.vim'
	endif
endif

autocmd FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 1
nmap <silent> <leader>ap <Plug>(ale_previous_wrap)
nmap <silent> <leader>an <Plug>(ale_next_wrap)

" jedi
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
" let g:jedi#force_py_version="2.7"
let g:jedi#goto_command = "<leader>gt"
let g:jedi#goto_assignments_command = "<leader>ga"
let g:jedi#goto_definitions_command = "<leader>gd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#completions_enabled = 0

