#!/usr/bin/env bash

function install_brew {
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  /usr/local/bin/brew install --build-from-source node npm yarn
}

function init {
  if [ "$OS"y == "Drawin"y ]; then
    xcode-select --install
  fi
  if ! command -v brew > /dev/null ; then
    install_brew
  fi
  if ! command -v neovim > /dev/null ; then
    brew install neovim
  fi
}

function install_search_tool {
  brew install --build-from-source the_silver_searcher
  [ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="${HOME}/.config"
  git clone --depth 1 https://github.com/junegunn/fzf.git "${XDG_CONFIG_HOME}"/fzf
  bash "${XDG_CONFIG_HOME}"/fzf/install --xdg
}

function install_zsh {
  brew install --build-from-source zsh
  if [ ! -d /etc/zsh ]; then
    if [ -z "${XDG_CONFIG_HOME}" ]; then
    sudo tee /etc/zshenv > /dev/null << EOF
export XDG_CONFIG_HOME="\${HOME}/.config"
export XDG_DATA_HOME="\$HOME/.local/share"
export XDG_CACHE_HOME="\$HOME/.cache"
export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh"
EOF
    fi
  else
    sudo tee -a /etc/zsh/zshenv > /dev/null << EOF
if [ -z \${XDG_CONFIG_HOME} ]; then
  export XDG_CONFIG_HOME="\${HOME}/.config"
  export XDG_DATA_HOME="\$HOME/.local/share"
  export XDG_CACHE_HOME="\$HOME/.cache"
fi
export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh"
EOF
  fi

  [ ! -d "$HOME/.local/share" ] && mkdir -p "$HOME/.local/share"
  [ ! -d "$HOME/.cache" ] && mkdir "$HOME/.cache"
  [ ! -d "$HOME/.config" ] && mkdir "$HOME/.config"
  [ -z "${XDG_CONFIG_HOME}" ] && export  XDG_CONFIG_HOME="${HOME}/.config"
  [ ! -d ${XDG_CONFIG_HOME}/.config/zsh ] && mkdir ${XDG_CONFIG_HOME}/.config/zsh
  # TODO zsh config
  export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}
