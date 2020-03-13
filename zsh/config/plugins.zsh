
# Initialize zimfw plugin system
export ZIM_HOME=$HOME/.zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

# fzf

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# Not open in fullscreen mode
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude "{.git,node_modules}"'
