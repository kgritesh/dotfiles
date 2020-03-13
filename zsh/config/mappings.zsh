# ZSH Key Bindings


# Set editor default keymap to emacs (`-e`)
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


# Edit cli
#autoload -z edit-command-line
#zle -N edit-command-line
#bindkey "^X^E" edit-command-line
