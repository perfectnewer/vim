[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME=${HOME}/.config
export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# for compat with bash complete
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
source ${HOME}/Documents/mconfig/sh/custom_bashrc

ZSH_THEME="ys"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/config
export NPM_CONFIG_CACHE=${XDG_CACHE_HOME}/npm

function change_brew() {
    set -x
    # brew 程序本身，Homebrew/Linuxbrew 相同
    git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
    # 以下针对 mac OS 系统上的 Homebrew
    git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
    git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
    git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
    git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
    # 以下针对 Linux 系统上的 Linuxbrew
    # git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/linuxbrew-core.git
    brew update
}

function recover_brew() {
	# brew 程序本身，Homebrew/Linuxbrew 相同
        git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
        # 以下针对 mac OS 系统上的 Homebrew
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
        git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
        git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://github.com/Homebrew/homebrew-cask-fonts.git
        git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://github.com/Homebrew/homebrew-cask-drivers.git
        # 以下针对 Linux 系统上的 Linuxbrew
        # git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/linuxbrew-core.git
        # 更换后测试工作是否正常
        brew update
}

function cht() {
	echo "change current window title to" $1;
	DISABLE_AUTO_TITLE="true"
	echo -ne "\e]1;$1\a"
}

function change_go_path() {
	matchGoSRc=$(echo $PWD | sed -E '/\/go\/src\//! d')
	if [ ! -z "$matchGoSRc" ]; then
		goPath=$(echo $PWD | sed -E 's|(^.*/go)/src/.*$|\1|')
		export GOPATH=$goPath
		export PATH=$PATH:${GOPATH}/bin

		echo "change gopath to ${GOPATH}"
	fi
}

# chpwd_functions=(${chpwd_functions[@]} "change_go_path")
command -v vg >/dev/null 2>&1 && eval "$(vg eval --shell zsh)"

# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias typora="open -a typora"
alias rmt=rmtrash.sh
alias brewi="brew install -v --build-from-source"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
