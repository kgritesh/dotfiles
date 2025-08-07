eval "$(/opt/homebrew/bin/brew shellenv)"
export ZSH_SHARE_PATH="$(brew --prefix)/share"
fpath=($ZSH_SHARE_PATH/zsh/site-functions $ZSH_SHARE_PATH/zsh-completions $fpath )
