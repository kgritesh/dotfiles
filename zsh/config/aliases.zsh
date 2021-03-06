# Add Aliases

# Git Aliases
alias gst="git status"


# Dir Aliases
alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."

alias md="mkdir -p"
alias rd="rmdir"
alias ds="dirs -vl"

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'


# VPN Aliases
alias stagingvpn="cd ${VPN_CONFIG_PATH} &&  sudo openvpn --config staging.ovpn --daemon && cd -"

# Misc Aliases
alias open="gio open"

alias -g xcopy="xclip -selection clipboard"

apply_zsh_config(){
    source ${ZSH_CONFIG_PATH}/$1.zsh
}

alias apply_zsh="source ~/.zshrc"

alias apply_alias="apply_zsh_config aliases"

ff(){
  find ${@[1, -2]} -name "${@[-1]}"
}

# `cd` to git repo root
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'

alias ag='rg'

alias install="yay --noconfirm -S"

alias uninstall="yay -R"

running() {
    ps -ef | grep $1
}

# Python Alias

pipfind() {
    pip freeze | grep $1
}


# editor aliases
alias emacs="emacsclient -c"
export EDITOR="emacs"


# Docker Aliases
alias dps="docker ps -a -q"

alias drc='docker rm $(docker ps -a -q)'

alias drcf='docker rm -f $(docker ps -a -q)'

alias dprune="docker system prune"

alias drmi="docker image prune -f"


# Hub Aliases
eval "$(hub alias -s)"

# Git aliases
alias gpo='git push origin `git branch --show-current`'
alias gpof='git push -f origin `git branch --show-current`'
alias gpull='git pull origin `git branch --show-current`'

commit-push() {
	git ci -a -m $1 && gpo
}

alias copyc="echo \"!!\" | xcopy"

wifi-connect() {
    nmcli connection up $1
}

add-alias() {
    echo "alias $1='$2'" >> ${ZSH_CONFIG_PATH}/.zcustom.zsh
}

add-path-alias() {
    echo "alias $1='cd $(pwd)'" >> ${ZSH_CONFIG_PATH}/.zcustom.zsh
}

ignore() {
    
}

activateScript() {
  for var in "$@"
  do
    DIR="$( cd "$( dirname $var )" && pwd )"
    sudo ln -s $DIR/"$var" /usr/bin/
  done
}


source ${ZSH_CONFIG_PATH}/.zcustom.zsh
