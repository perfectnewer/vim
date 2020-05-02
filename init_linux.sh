#!/usr/bin/env bash

function init() {
  sudo apt install -y neovim git build-essential golang nodejs npm
}

function install_zsh {
  sudo apt install zsh -y
  [ ! -d "/etc/zsh" ] && sudo mkdir /etc/zsh
  sudo tee -a /etc/zsh/zshenv > /dev/null << EOF
if [ -z \${XDG_CONFIG_HOME} ]; then
  export XDG_CONFIG_HOME="\${HOME}/.config"
  export XDG_DATA_HOME="\$HOME/.local/share"
  export XDG_CACHE_HOME="\$HOME/.cache"
fi
export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh"
EOF
  [ -z "${XDG_CONFIG_HOME}" ] && export  XDG_CONFIG_HOME="${HOME}/.config"
  [ ! -d ${XDG_CONFIG_HOME}/.config/zsh ] && mkdir ${XDG_CONFIG_HOME}/.config/zsh
  # TODO zsh config
  export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

