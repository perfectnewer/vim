#!/usr/bin/env bash

function my_install {
    INSTALL_SOFT=install_$1
    ${INSTALL_SOFT} $([[ $# -gt 1 ]] && echo $@ | cut -d' ' -f 2-)
    unset INSTALL_SOFT
}

function install_pip {
    if [ -z $(which pip) ]; then
    if [ -n "$*" ]; then
            easy_install $@ pip
    else
        easy_install --user -v pip
        fi
    else
        pip install pip --upgrade
    fi;

}

function init_python {
    MY_PYTHON_USER_BASE=$(python -c 'import site; print site.USER_BASE')
}

# git clone git://github.com/altercation/solarized.git

function install_brew {
     ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_config {
    mkdir -p ${HOME}/.config/
    LINK_CFG=(git .config/git git/gitconfig .gitconfig  pip  .pip  ssh .ssh zshrc .zshrc vim .vim vim .config/nvim)
    LINK_LEN=$[${#LINK_CFG[@]}-1]
    set +x
    for idx in $(seq 0 2 ${LINK_LEN} ); do
        SRC="$(pwd)/${LINK_CFG[idx]}"
        TARGET="${HOME}/${LINK_CFG[idx+1]}"
        if [ -d "${TARGET}" ]; then
           ls -l "${TARGET}"
           read -p "Target ${TARGET} exists, delete and link?" yn
           case $yn in
               [Yy]* ) rm -fr "${TARGET}" && ln -s -i "${SRC}" "${TARGET}" ;;
               * ) echo "Skip ";;
           esac
        else
           ln -s -i "${SRC}" "${TARGET}"
        fi
    done
    set -x
}

function install_commandline {
    xcode-select --install
}

function install_myzsh {
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

if [ -n "$1" ];then
    for i in $@; do
        echo "install $i"
        my_install $i
    done
fi

# if [ -n "$1" ];then
#     my_install $@
# else
#     my_install all
# fi
