export KEY_BACKSPACE='^?'
export KEY_CMD_C='^[[27;6;67~'
export KEY_CMD_LEFT='^A'
export KEY_CMD_RIGHT='^E'
export KEY_DELETE='^[[3~'
export KEY_FN_CTRL_X='^X'
export KEY_LEFT='^[[D'
export KEY_RIGHT='^[[C'
export KEY_SHIFT_CMD_LEFT='^[[1;10D'
export KEY_SHIFT_CMD_RIGHT='^[[1;10C'
export KEY_SHIFT_LEFT='^[[1;2D'
export KEY_SHIFT_OPT_LEFT='^[[1;4D'
export KEY_SHIFT_OPT_RIGHT='^[[1;4C'
export KEY_SHIFT_RIGHT='^[[1;2C'

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

# copy selected terminal text to clipboard
zle -N widget::copy-selection
function widget::copy-selection {
    if ((REGION_ACTIVE)); then
        zle copy-region-as-kill
				printf "%s" $CUTBUFFER | pbcopy
    fi
}

# cut selected terminal text to clipboard
zle -N widget::cut-selection
function widget::cut-selection() {
    if ((REGION_ACTIVE)) then
        zle kill-region
				printf "%s" $CUTBUFFER | pbcopy
    fi
}

# paste clipboard contents
zle -N widget::paste
function widget::paste() {
    ((REGION_ACTIVE)) && zle kill-region
		RBUFFER="$(wl-paste)${RBUFFER}"
		CURSOR=$(( CURSOR + $(echo -n "$(pbpaste)" | wc -m | bc) ))
}

# select entire prompt
zle -N widget::select-all
function widget::select-all() {
    local buflen=$(echo -n "$BUFFER" | wc -m | bc)
    CURSOR=$buflen   # if this is messing up try: CURSOR=9999999
    zle set-mark-command
    while [[ $CURSOR > 0 ]]; do
        zle beginning-of-line
    done
}

# scrolls the screen up, in effect clearing it
zle -N widget::scroll-and-clear-screen
function widget::scroll-and-clear-screen() {
    printf "\n%.0s" {1..$LINES}
    zle clear-screen
}

function widget::util-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
    zle copy-region-as-kill
		printf "%s" $CUTBUFFER | pbcopy
}

function widget::util-unselect() {
    REGION_ACTIVE=0
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

function widget::util-insertchar() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="${1}${RBUFFER}"
    zle forward-char
}

bindkey $KEY_CMD_C widget::copy-selection
bindkey $KEY_FN_CTRL_X widget::cut-selection

# Removed custom right arrow binding - let the loop handle it

# NOTE: "keyname" column is arbitrarily descriptive.
#
for keyname           kcap   seq                   mode       widget (
    # LEFT/RIGHT seems pointless but they specifically UNSELECT text.
    left              kcub1  $KEY_LEFT             unselect   backward-char
    right             kcuf1  $KEY_RIGHT            unselect   forward-char

		# DELETE/BACKSPACE seems pointless but they specifically delete selected text.
    del               x      $KEY_DELETE           delselect  delete-char
    backspace         x      $KEY_BACKSPACE        delselect  backward-delete-char

    cmd-left          x      $KEY_CMD_RIGHT        unselect   end-of-line
    cmd-right         x      $KEY_CMD_LEFT         unselect   beginning-of-line
    shift-cmd-left    x      $KEY_SHIFT_CMD_LEFT   select     beginning-of-line
    shift-cmd-right   x      $KEY_SHIFT_CMD_RIGHT  select     end-of-line
    shift-ctrl-left   x      $KEY_SHIFT_OPT_LEFT   select     backward-word
    shift-ctrl-right  x      $KEY_SHIFT_OPT_RIGHT  select     forward-word
    shift-left        kLFT   $KEY_SHIFT_LEFT       select     backward-char
    shift-right       kRIT   $KEY_SHIFT_RIGHT      select     forward-char
) {
    eval "function widget::key-$keyname() {
        widget::util-$mode $widget \$@
    }"
    zle -N widget::key-$keyname
    bindkey $seq widget::key-$keyname
}
