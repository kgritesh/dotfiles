export ZSH_CONFIG_PATH=$ZDOTDIR/config
export ZSH_FUNC_PATH=$ZDOTDIR/funcs
export ZCUSTOM_PATH=$ZDOTDIR/.zcustom.zsh

# Here, not .zshrc: non-interactive shells (CI, ssh, agents, IDEs) never read .zshrc, so
# `mise activate` never runs for them. Shims resolve the tool per-directory at exec time
# instead. Interactive shells still get activate, which prepends ahead of these.
# https://mise.jdx.dev/dev-tools/shims.html#shims-vs-path
export PATH="$HOME/.local/share/mise/shims:$PATH"
