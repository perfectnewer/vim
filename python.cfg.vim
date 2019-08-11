autocmd BufNewFile
    \ *.py
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ call append(0, "#!/usr/bin/env python") |
    \ call append(1, "# coding: utf-8")

autocmd FileType python
    \ setlocal expandtab | setlocal tabstop=4 |
    \ setlocal softtabstop=4 | setlocal shiftwidth=4 |
    \ setlocal autoindent | setlocal fileformat=unix

let g:deoplete#sources#jedi#show_docstring=1
let g:python_host_prog = '/Users/simon/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/simon/.pyenv/versions/neovim3/bin/python'
let g:pymode_indent = 0

"python with virtualenv support
if has('python')
python << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
elseif has('python3')
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  with open(activate_this, 'r') as f:
    exec(f.read(), dict(__file__=activate_this))
EOF
endif

autocmd FileType python nnoremap <LocalLeader>i :!isort %<CR><CR>
