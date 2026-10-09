# Use fd for fzf's default source (respects .gitignore, includes hidden, skips .git)
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Built-in shell integration: Ctrl+T (files), Ctrl+R (history), Alt+C (cd), Tab completion
source <(fzf --zsh)

# Taken from https://polothy.github.io/post/2019-08-19-fzf-git-checkout/
fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch
    branch=$(fzf-git-branch)
    if [[ -z "$branch" ]]; then
        echo "No branch selected."
        return
    fi

    if [[ "$branch" = 'remotes/'* ]]; then
        git switch --track "$branch"
    else
        git switch "$branch"
    fi
}

# Confirm-then-delete branch (local or remote). Pass -f for force-delete.
fzf-git-delete() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local force_flag="-d"
    if [[ "$1" = "-f" ]]; then
        force_flag="-D"
    fi

    local branch
    branch=$(fzf-git-branch)
    if [[ -z "$branch" ]]; then
        echo "No branch selected."
        return
    fi

    if [[ "$branch" =~ 'remotes/([^/]+)/(.+)' ]]; then
        local remote="${match[1]}"
        local remote_branch="${match[2]}"
        printf "Delete REMOTE branch %s/%s? [y/N] " "$remote" "$remote_branch"
        read -r confirm
        [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; return; }
        git push "$remote" ":$remote_branch"
    else
        git branch "$force_flag" "$branch"
    fi
}

alias gb='fzf-git-branch'
alias gco='fzf-git-checkout'
alias gdel='fzf-git-delete'
alias gdel-force='fzf-git-delete -f'
