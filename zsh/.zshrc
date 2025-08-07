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

if [ -f "${ZDOTDIR}/.zcustom.zsh" ]; then
    source "${ZDOTDIR}/.zcustom.zsh"
fi


# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
    source "${ZSH_CONFIG_PATH}/fzf.zsh"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


alias claude="/Users/vertexcover/.claude/local/claude"
