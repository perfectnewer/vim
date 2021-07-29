#!/usr/bin/env bash

function init() {
  sudo apt install -y neovim git build-essential golang nodejs npm clang ssh
  sudo apt install -y zlib readline libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev \
      	libreadline-gplv2-dev libsqlite3-dev tk-dev libbz2-dev

}

function install_search_tool {
  sudo apt install silversearcher-ag -y
  [ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME="${HOME}/.config"
  git clone --depth 1 https://github.com/junegunn/fzf.git "${XDG_CONFIG_HOME}"/fzf
  bash "${XDG_CONFIG_HOME}"/fzf/install --xdg
}

function install_zsh {
  sudo apt install -y zsh
  sudo tee -a /etc/zsh/zshenv > /dev/null << EOF
if [ -z \${XDG_CONFIG_HOME} ]; then
  export XDG_CONFIG_HOME="\${HOME}/.config"
  export XDG_DATA_HOME="\$HOME/.local/share"
  export XDG_CACHE_HOME="\$HOME/.cache"
fi
export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh"
EOF

  [ ! -d "$HOME/.local/share" ] && mkdir -p "$HOME/.local/share"
  [ ! -d "$HOME/.cache" ] && mkdir "$HOME/.cache"
  [ ! -d "$HOME/.config" ] && mkdir "$HOME/.config"

  [ -z "${XDG_CONFIG_HOME}" ] && export  XDG_CONFIG_HOME="${HOME}/.config"
  [ ! -d ${XDG_CONFIG_HOME}/zsh ] && mkdir ${XDG_CONFIG_HOME}/zsh
  # TODO zsh config
  export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function install_docker() {
  sudo apt remove -y docker docker-engine docker.io containerd runc
  sudo apt install -y apt-transport-https ca-certificates curl
    gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"
  sudo apt update -y
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker your-use
}
