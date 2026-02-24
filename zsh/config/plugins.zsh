source ${ZSH_SHARE_PATH}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${ZSH_SHARE_PATH}/zsh-autosuggestions/zsh-autosuggestions.zsh

# Configure autosuggestions to accept with right arrow and enter
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(forward-char accept-line)

# source ${ZSH_SHARE_PATH}/zsh-autocomplete/zsh-autocomplete.plugin.zsh  # Disabled - breaks tab completion
source ${ZSH_SHARE_PATH}/zsh-history-substring-search/zsh-history-substring-search.zsh
