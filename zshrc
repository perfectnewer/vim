export ZSH=${HOME}/Documents/mconfig/oh-my-zsh
ZSH_CUSTOM=$ZSH

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

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

alias typora="open -a typora"
alias rmt=rmtrash.sh

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

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/simon/Desktop/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/simon/Desktop/google-cloud-sdk/completion.zsh.inc'; fi
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/simon/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/simon/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/simon/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/simon/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
