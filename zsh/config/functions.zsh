


### System clipboard integration


### Profile Clipboard

zshtime(){
    for i in $(seq 1 10); do time  zsh -i -c exit; done
}


###fzf Aliases

# Kill process using fzf

fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}


# Open the selected file

fo() (
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  echo $file
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || emacs "$file"
  fi
)
