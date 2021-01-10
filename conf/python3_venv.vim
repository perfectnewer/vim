python3 << EOF
import os
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    # python_bin = os.path.join(project_base_dir, 'bin/python')
    # vim.command(":call SetPythonBinaryPath('{}')".format(python_bin))
    # vim.command("let g:python_host_prog = '{}'".format(python_bin))

    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    if os.path.exists(activate_this):
        with open(activate_this, 'r') as f:
            exec(f.read(), dict(__file__=activate_this))
EOF
