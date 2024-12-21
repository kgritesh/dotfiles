# Add Aliases

# Git Aliases
alias gst="git status"
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias gsoft='git reset HEAD'
alias ghard='git reset --hard HEAD'
alias gpo='git push origin `git branch --show-current`'
alias gpof='git push -f origin `git branch --show-current`'
alias gpull='git pull origin `git branch --show-current`'

commit-push() {
	git ci -a -m $1 && gpo
}
gdiff() {
    git difftool --dir-diff --tool=meld "${1:-HEAD}" "${2:-HEAD~}"
}
alias glast="git rev-parse HEAD | tr -d '\n' | xcopy"
alias gfo='git fetch origin'

# Misc
alias cat='bat'
alias tmux-attach='tmux attach-session -t'
alias ffres='ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0'
alias dc='docker-compose'

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


apply_zsh_config(){
    source ${ZSH_CONFIG_PATH}/$1.zsh
}

alias apply_zsh="source $ZDOTDIR/.zshrc"
alias apply_alias="apply_zsh_config aliases"


# Docker Aliases
alias dps="docker ps -a -q"

alias drc='docker rm $(docker ps -a -q)'

alias drcf='docker rm -f $(docker ps -a -q)'

alias dprune="docker system prune"

alias drmi="docker image prune -f"
alias ffmpeg="ffmpeg -hide_banner"
alias ffprobe="ffprobe -hide_banner"
alias sqs-atth-msg='aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/223742092451/ritesh_kadmawala-dev-atth-request-queue --message-body'
