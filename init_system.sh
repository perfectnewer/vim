#!/usr/bin/env bash

export OS=$(uname)

function drawin_zsh_env {
  brew install --build-from-source zsh
  if [ ! -d /etc/zshenv ]; then
    if [ -z "${XDG_CONFIG_HOME}" ]; then
    sudo cat > /etc/zshenv << EOF
  export XDG_CONFIG_HOME="${HOME}/.config"
  export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
EOF
  else
    sudo cat > /etc/zshenv << EOF
  export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
EOF
  fi
}

function linux_zsh_env {
  sudo apt install zsh -y
  [ ! -d "/etc/zsh" ] && sudo mkdir /etc/zsh
  echo 'export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"' >> /etc/zsh/zshenv
}

function install_zsh {
  if [ "$OS"y == "Drawin"y ]; then
    drawin_zsh_env
  elif [ "$OS"y == "Linux"y ]; then
    linux_zsh_env
  fi
  [ -z "${XDG_CONFIG_HOME}" ] && export  XDG_CONFIG_HOME="${HOME}/.config"
  [ ! -d ${XDG_CONFIG_HOME}/.config/zsh ] && mkdir ${XDG_CONFIG_HOME}/.config/zsh
  # TODO zsh config
  export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

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

function install_brew {
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /usr/local/bin/brew install --build-from-source node npm
}

function install_config {
    mkdir -p ${HOME}/.config/
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

function install_commandline {
  if [ "$OS"y == "Drawin"y ]; then
    xcode-select --install
  fi
}

function install_search_tool {
  if [ "$OS"y == "Drawin" ]; then
    brew install --build-from-source the_silver_searcher
  else
    sudo apt install silversearcher-ag -y
  fi
  [ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="${HOME}/.config"
  git clone --depth 1 https://github.com/junegunn/fzf.git "${XDG_CONFIG_HOME}"/fzf
  bash "${XDG_CONFIG_HOME}"/fzf/install --xdg
}

function install_pyenv_nvim {
  export PYENV_ROOT=${HOME}/.config/pyenv/
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
  if [ ! -d $(PYENV_ROOT)/plugins/pyenv-virtualenv ] ; then
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(PYENV_ROOT)/plugins/pyenv-virtualenv
  fi

  pyenv=$(PYENV_ROOT)/bin/pyenv
  v=3.7.7 && wget http://mirrors.sohu.com/python/$v/Python-$v.tar.xz -P $(PYENV_ROOT)/cache/ && $(pyenv) install $v
  v=2.7.17 && wget http://mirrors.sohu.com/python/$v/Python-$v.tar.xz -P $(PYENV_ROOT)/cache/ && $(pyenv) install $v

  $(pyenv) virtualenv 2.7.17 neovim2
  $(pyenv) virtualenv 3.7.7 neovim3
  $(PYENV_ROOT)/versions/2.7.17/bin/pip install neovim flake8
  $(PYENV_ROOT)/versions/3.7.7/bin/pip install neovim flake8
  export NPM_CONFIG_USERCONFIG=${HOME}/.config/npm/config
  export NPM_CONFIG_CACHE=${HOME}/.config/npm
  /usr/local/bin/npm install -g neovim
}

function my_install {
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
