export ZSH_SHARE_PATH="/usr/share"
alias install="yay --noconfirm -S"

alias uninstall="yay -R"
alias disable-laptop-screen='xrandr --output eDP-1 --off'
alias enable-laptop-screen='xrandr --output eDP-1 --auto --right-of DP-1'
alias -g xcopy="xclip -selection clipboard"

wifi-connect() {
    nmcli connection up $1
}

# ZSH Key Bindings


bindkey -e

# Ctrl-z to undo
bindkey '^z' undo

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

# zsh-history-substring-search
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
export BROWSER="/usr/bin/google-chrome-stable"
