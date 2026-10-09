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

export fpath=($ZSH_FUNC_PATH $HOME/.zfunc $fpath)

# Initialize completions with performance optimization
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

source $ZSH_CONFIG_PATH/plugins.zsh

source $ZSH_CONFIG_PATH/options.zsh

source $ZSH_CONFIG_PATH/functions.zsh

source $ZSH_CONFIG_PATH/aliases.zsh

source $ZSH_CONFIG_PATH/text-selection.zsh

if [ -f "${ZDOTDIR}/.zcustom.zsh" ]; then
    source "${ZDOTDIR}/.zcustom.zsh"
fi


# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
    source "${ZSH_CONFIG_PATH}/fzf.zsh"
fi

compdef _files copy-path
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

if [ -f "${ZDOTDIR}/.zlocal.zsh" ]; then
    source "${ZDOTDIR}/.zlocal.zsh"
fi
