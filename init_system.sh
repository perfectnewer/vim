#!/usr/bin/env bash

export OS=$(uname)

function install_pip {
    if [ -z $(which pip) ]; then
    if [ -n "$*" ]; then easy_install $@ pip
    else
        easy_install --user -v pip
        fi
    else
        pip install pip --upgrade
    fi;

}

# git clone git://github.com/altercation/solarized.git

function install_config {
    mkdir -p ${HOME}/.config/pip ${HOME}/.config/git/ ${HOME}/.config/nvim/ ${HOME}/.config/zsh/ \
        ${HOME}/.config/tmux/ 

    LINK_CFG=(git .config/git pip .config/pip  ssh .ssh zshrc .config/zsh/.zshrc vim .vim vim .config/nvim)
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

function install_pyenv_nvim {
  export PYENV_ROOT=${HOME}/.config/pyenv
  if command -v curl > /dev/null ; then
    wget https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer -O - | bash
  else
    curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  fi
  if [ ! -d ${PYENV_ROOT}/plugins/pyenv-virtualenv ] ; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
  fi

  pyenv=${PYENV_ROOT}/bin/pyenv
  v=3.7.7 && wget http://mirrors.sohu.com/python/$v/Python-$v.tar.xz -P ${PYENV_ROOT}/cache/ && eval ${pyenv} install $v
  v=2.7.17 && wget http://mirrors.sohu.com/python/$v/Python-$v.tar.xz -P ${PYENV_ROOT}/cache/ && eval ${pyenv} install $v

  eval ${pyenv} virtualenv 2.7.17 neovim2
  eval ${pyenv} virtualenv 3.7.7 neovim3
  ${PYENV_ROOT}/versions/neovim2/bin/pip install neovim flake8 jedi
  ${PYENV_ROOT}/versions/neovim3/bin/pip install neovim flake8 jedi
  export NPM_CONFIG_USERCONFIG=${HOME}/.config/npm/config
  export NPM_CONFIG_CACHE=${HOME}/.config/npm
  sudo npm install -g neovim
}

if [ "$OS"y == "Drawin"y ]; then
  source init_mac.sh
elif [ "$OS"y == "Linux"y ]; then
  source init_ubuntu.sh
fi

function my_install {
  echo 'init first'
  init
  echo 'start install'
  INSTALL_SOFT=install_$1
  ${INSTALL_SOFT} $([[ $# -gt 1 ]] && echo $@ | cut -d' ' -f 2-)
  unset INSTALL_SOFT
}

function install_all {
  for component in config commandline brew pip zsh zsh_env search_tool pyenv_nvim; do
    my_install ${component}
  done
}

if [ -n "$1" ];then
    for i in $@; do
        echo "install $i"
        my_install $i
    done
else
  read -p "install all?" yn
  case $yn in
     [Yy]* ) install_all ;;
     * ) echo "Skip ";;
  esac
fi
