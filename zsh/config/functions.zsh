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

# Manage a .env file: denv set|get|rm|ls|find  (file: $ENV_FILE or ./.env)
denv() {
    local file="${ENV_FILE:-.env}"
    local cmd="$1"
    shift 2>/dev/null

    _denv_valid_key() {
        [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "denv: bad key '$1'"; return 1; }
    }

    _denv_without_key() {
        awk -v k="$1" '$0 !~ "^(export[ \t]+)?" k "="' "$file"
    }

    case "$cmd" in
        set|add)
            local key value
            if [ "$#" -eq 1 ] && [[ "$1" == *=* ]]; then
                key="${1%%=*}"; value="${1#*=}"
            elif [ "$#" -eq 2 ]; then
                key="$1"; value="$2"
            else
                echo "Usage: denv set KEY VALUE  |  denv set KEY=VALUE"; return 1
            fi
            _denv_valid_key "$key" || return 1
            touch "$file"
            local rest="$(_denv_without_key "$key")"
            { [ -n "$rest" ] && printf '%s\n' "$rest"; printf '%s=%s\n' "$key" "$value"; } > "$file"
            echo "set $key in $file"
            ;;
        get)
            [ "$#" -eq 1 ] || { echo "Usage: denv get KEY"; return 1; }
            _denv_valid_key "$1" || return 1
            [ -f "$file" ] || { echo "denv: no $file"; return 1; }
            grep -E "^(export[[:space:]]+)?$1=" "$file" | tail -1 | cut -d= -f2-
            ;;
        rm|remove|del)
            [ "$#" -ge 1 ] || { echo "Usage: denv rm KEY [KEY...]"; return 1; }
            [ -f "$file" ] || { echo "denv: no $file"; return 1; }
            local key rest
            for key in "$@"; do
                _denv_valid_key "$key" || return 1
                grep -qE "^(export[[:space:]]+)?$key=" "$file" || { echo "not found: $key"; continue; }
                rest="$(_denv_without_key "$key")"
                { [ -n "$rest" ] && printf '%s\n' "$rest"; } > "$file"
                echo "removed $key from $file"
            done
            ;;
        ls|list|view|"")
            [ -f "$file" ] || { echo "denv: no $file"; return 1; }
            grep -vE '^[[:space:]]*(#|$)' "$file"
            ;;
        find|search)
            [ "$#" -eq 1 ] || { echo "Usage: denv find PATTERN"; return 1; }
            [ -f "$file" ] || { echo "denv: no $file"; return 1; }
            grep -inE -- "$1" "$file"
            ;;
        *)
            echo "Usage: denv {set|get|rm|ls|find}  (file: \${ENV_FILE:-.env})"; return 1
            ;;
    esac
}
