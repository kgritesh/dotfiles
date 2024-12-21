zshtime(){
    for i in $(seq 1 10); do time  zsh -i -c exit; done
}

npm () {
    if grep -sq 'pnpm' package.json; then pnpm $@; else command npm $@; fi
}

gitignore() {
    for var in "$@"
    do
        echo "$var" >> .gitignore
    done
}

activateScript() {
  for var in "$@"
  do
    DIR="$( cd "$( dirname $var )" && pwd )"
    sudo ln -s $DIR/"$var" /usr/bin/
  done
}


_add_alias_to_file() {
    local alias_name="$1"
    local alias_command="$2"
    local target_file="$3"

    if grep -q "^alias $alias_name=" "$target_file" 2>/dev/null; then
        echo "Alias '$alias_name' already exists in $target_file."
        return 1
    fi

    echo "$alias_command" >> "$target_file"
    echo "Alias '$alias_name' added to $target_file."

    source "$target_file"
}

# Function to add a general alias to aliases.zsh
add-alias() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: add-alias alias_name command"
        return 1
    fi

    local alias_name="$1"
    local command="$2"
    local target_file="${ZSH_CONFIG_PATH}/aliases.zsh"
    local alias_line="alias $alias_name='$command'"

    _add_alias_to_file "$alias_name" "$alias_line" "$target_file"
}

# Function to add a custom alias to .zcustom.sh
add-custom-alias() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: add-custom-alias alias_name command"
        return 1
    fi

    local alias_name="$1"
    local command="$2"
    local target_file="${ZSH_CONFIG_PATH}/.zcustom.zsh"
    local alias_line="alias $alias_name='$command'"

    _add_alias_to_file "$alias_name" "$alias_line" "$target_file"
}

add-path-alias() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: add-path-alias alias_name"
        return 1
    fi

    local alias_name="$1"
    local current_path="$(pwd)"
    local target_file="${ZSH_CONFIG_PATH}/.zcustom.zsh"
    local alias_line="alias $alias_name='cd $current_path'"

    _add_alias_to_file "$alias_name" "$alias_line" "$target_file"
}

running() {
    ps -ef | grep $1
}

# Python Alias

pipfind() {
    pip freeze | grep $1
}
