# ZSH config File
# -------------------------------------------------------------------------------
# Configuration Files
# -------------------------------------------------------------------------------
if [ -f "/etc/arch-release" ]; then
    if [ -f "${ZDOTDIR}/.zarch.zsh" ]; then
        source "${ZDOTDIR}/.zarch.zsh"
    fi
fi

if [[ "$(uname)" == "Darwin" ]]; then
    source "${ZDOTDIR}/.zmacos.zsh"
fi
source $ZSH_CONFIG_PATH/plugins.zsh

source $ZSH_CONFIG_PATH/options.zsh

source $ZSH_CONFIG_PATH/functions.zsh

source $ZSH_CONFIG_PATH/aliases.zsh

if [ -f "${ZDOTDIR}/.zcustom.zsh" ]; then
    source "${ZDOTDIR}/.zcustom.zsh"
fi


# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
    source "${ZSH_CONFIG_PATH}/fzf.zsh"
fi
