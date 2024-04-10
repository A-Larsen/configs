alias la='ls -A'
alias e-vim='cd /usr/share/vim/vim82/ && sudo vim'
alias FLOOP='for ((i=1;i<=${#FILES[@]};i++)); do file=${FILES[i]}'
alias DLOOP='for ((i=1;i<=${#DIRS[@]};i++)); do dir=${DIRS[i]}'
alias LLOOP='for ((i=1;i<=${#LINKS[@]};i++)); do link=${LINKS[i]}'
alias lnF="cd $(readlink -f .)"
alias fzf="fzf --height=20"
alias fvim="vim \$(fzf)"

if [[ "$0" = "bash" ]]; then
    alias HELPME="firefox /usr/share/doc/bash/bash.html 2> /dev/null &"
    alias HELPGREG="firefox https://mywiki.wooledge.org/BashGuide 2> /dev/null &"

    alias LLOOP='for idx in ${!LINKS[@]}; do link=${LINKS[idx]}'
    alias FLOOP='for idx in ${$FILES[@]}; do file=${FILES[idx]}'
    alias DLOOP='for idx in ${$DIRS[@]}; do dir=${DIRS[idx]}'

    alias LLOOP='for idx in ${$LINKS[@]}; do link=${LINKS[idx]}'
fi
