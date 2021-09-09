[ -z "${XDG_CONFIG_HOME}" ] && export XDG_CONFIG_HOME=${HOME}/.config
export ZSH=${XDG_CONFIG_HOME}/zsh/oh-my-zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export OS="$(uname -s)"
if [[ "$OS" =~ "[Ll]nux*" ]]; then
    export OS_LINUX=1
else
    export OS_LINUX=0
fi

# for compat with bash complete
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
source ${HOME}/Documents/mconfig/sh/custom_bashrc

ZSH_THEME="ys"  # robbyrussell

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
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/linuxbrew-bottles"
export NPM_CONFIG_USERCONFIG=${XDG_CONFIG_HOME}/npm/config
export NPM_CONFIG_CACHE=${XDG_CACHE_HOME}/npm

function change_brew() {
    set -x
    # brew 程序本身，Homebrew/Linuxbrew 相同
    git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

    BREW_TAPS="$(brew tap)"
    for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
        if echo "$BREW_TAPS" | grep -qE "^homebrew/${tap}\$"; then
            # 将已有 tap 的上游设置为本镜像并设置 auto update
            # 注：原 auto update 只针对托管在 GitHub 上的上游有效
            git -C "$(brew --repo homebrew/${tap})" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
            git -C "$(brew --repo homebrew/${tap})" config homebrew.forceautoupdate true
        else   # 在 tap 缺失时自动安装（如不需要请删除此行和下面一行）
            brew tap --force-auto-update homebrew/${tap} https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
        fi
    done

    if [[ "$OS" =~ "[Ll]nux*" ]]; then
    	git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/linuxbrew-core.git
    fi

    echo "reset brew head"
    brew update-reset
}

function recover_brew() {
    # brew 程序本身，Homebrew/Linuxbrew 相同
    git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git

    BREW_TAPS="$(brew tap)"
    for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
        if echo "$BREW_TAPS" | grep -qE "^homebrew/${tap}\$"; then
            # 将已有 tap 的上游设置为本镜像并设置 auto update
            # 注：原 auto update 只针对托管在 GitHub 上的上游有效
            git -C "$(brew --repo homebrew/${tap})" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
            git -C "$(brew --repo homebrew/${tap})" config homebrew.forceautoupdate true
        else   # 在 tap 缺失时自动安装（如不需要请删除此行和下面一行）
            brew tap --force-auto-update homebrew/${tap} https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git
        fi
    done

    # 以下针对 Linux 系统上的 Linuxbrew
    if [[ "$OS" =~ "[Ll]nux*" ]]; then
        git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/linuxbrew-core.git
    fi

    echo "reset brew head"
    brew update-reset
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
alias server="ssh server"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
if [[ $OS_LINUX == 1 ]]; then
    linux_brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
    if [[ -f $linux_brew_bin ]]; then
        eval $(${linux_brew_bin} shellenv)
    fi
fi
export PATH="${HOME}/.cargo/bin:${PATH}"
