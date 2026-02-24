export EDITOR='zed'

export VISUAL='zed'
export JAVA_HOME=$(brew --prefix)/opt/openjdk@17


export PATH="$HOME/.local/bin:$PATH"

eval "$(/opt/homebrew/bin/mise activate zsh)"

# Enable colors for terminal
export CLICOLOR=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

# Colored prompt: blue directory path + prompt symbol
export PS1="%F{blue}%~%f %# "
