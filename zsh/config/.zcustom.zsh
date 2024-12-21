alias pashi='cd /home/krg85/Projects/pashi'
alias pashi-core='cd /home/krg85/Projects/pashi/pashi-dsl-backend'
alias consultproj='cd /home/krg85/Projects/consulting-calculator'
alias pashi-lib-user='cd /home/krg85/Projects/golang/src/lib_user'
alias emserver='/usr/bin/emacs'
alias ssh='TERM='xterm-256color' ssh'
alias pashi-ssh='ssh -t dell@1.tcp.in.ngrok.io -p 22262 "cd /home/dell/dev/pashi/src/pashi-dsl-backend; bash --login"'
alias gsoft='git reset HEAD'
alias ghard='git reset --hard HEAD'
alias cat='bat'
alias rephrase='cd /home/krg85/Projects/rephrase-ai'
alias rephcloud='ssh rephcloud'
alias sync-wpb='sync-watcher ./ gpu-common.dev.gcp.rephrase.ai "~/web_panel_backend"'
alias wpb='cd /home/krg85/Projects/rephrase-ai/web_panel_backend'
alias rephfront='cd /home/krg85/Projects/rephrase-ai/web_panel_common'
alias rcloud-pf='ssh -N -L 8000:127.0.0.1:8000 riteshkadmawala@gpu-common.dev.gcp.rephrase.ai'
alias tmux-attach='tmux attach-session -t'
alias rephttv='cd /home/krg85/Projects/rephrase-ai/ttn'
alias conda-wpb='conda'
alias liveth='cd /home/krg85/Projects/rephrase-ai/liveth'
alias djshell='python'
alias vishwakarma='ssh ubuntu@34.83.242.233'
alias joblog='ssh rephcloud joblog'
alias postprod='cd /home/krg85/Projects/rephrase-ai'
alias resolution='ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0'
alias tta='cd /home/krg85/Projects/rephrase-ai/text_to_audio && conda activate tta'

wpb-scp () {
    scp $1:~/web_panel_backend/$2 `dirname $2`
}
alias dc='docker-compose'
alias uc='cd /home/krg85/Projects/Dhiwise/unified-components'
alias rve='cd /home/krg85/Projects/rephrase-ai/video-engine'
alias rvecomp='cd /home/krg85/Projects/rephrase-ai/video-engine/packages/video-components'
alias atth='cd /home/krg85/Projects/rephrase-ai/atth'
alias job-folders='cd /home/krg85/Downloads/job-folders'

aws-stop-instance () {
    echo "Stopping instance $1"
    aws ec2 describe-instances --filters "Name=tag:Name,Values=${1}" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text | xargs aws ec2 stop-instances --instance-ids
}

aws-start-instance () {
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=stopped" --query "Reservations[*].Instances[*].InstanceId" --output text | xargs aws ec2 start-instances --instance-ids
}
alias postprod='cd /home/krg85/Projects/rephrase-ai/video-engine/packages/postprod'
alias video-engine='cd /home/krg85/Projects/rephrase-ai/video-engine'
alias rephcomp='cd /home/krg85/Projects/rephrase-ai/video-engine/packages/video-components'
alias gategpt='cd /home/krg85/Projects/custom-gpts-paywall'
alias ecj='cd /home/krg85/Projects/ecj-backend'
alias shopist='cd /home/krg85/Projects/shopify-product-search'
alias albus-be='cd /home/krg85/Projects/Springworks/albus-be'
alias dobby-be='cd /home/krg85/Projects/Springworks/dobby-be'
alias flowtest='cd /home/krg85/Projects/flowtest'
alias odn='cd /home/krg85/Projects/odn/odn-postprod'
alias madmen='cd /home/krg85/Projects'
alias americana='cd /home/krg85/Projects/attributics/americana-360'
