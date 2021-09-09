# -*- coding: utf-8 -*-
import os
import site
import sys

if 'VIRTUAL_ENV' in os.environ:
    base_dir = os.path.realpath(os.environ['VIRTUAL_ENV'])

    # add the virtual environments libraries to the host python import mechanism
    prev_length = len(sys.path)

    for lib in ["lib", "lib64"]:
        lib_dir = os.path.join(base_dir, lib)
        if os.path.exists(lib_dir):
            for dir_name in os.listdir(lib_dir):
                if dir_name.startswith("python") and os.path.isdir(os.path.join(lib_dir, dir_name)):
                    path = os.path.realpath(os.path.join(lib_dir, dir_name, "site-packages"))
                    site.addsitedir(path)

    sys.path[:] = sys.path[prev_length:] + sys.path[0:prev_length]

    sys.real_prefix = sys.prefix
    sys.prefix = base_dir
    print(sys.path)
