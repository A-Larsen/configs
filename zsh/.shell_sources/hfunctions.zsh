_PS1_timer_start(){ 
  timer=${timer:-$SECONDS}
}

_PS1_timer_stop(){
  timer_show=$(($SECONDS - $timer))
  unset timer
}

_PS1_parse_file_type(){

    if [[ ! -z "$ISBRANCH" ]]; 
    then
        echo -en "\e[42m\e[30m $ISBRANCH● \e[49m\e[32m"

        elif [[ ! -z "$ISPROJECT" ]]
        then
            echo -ne "${CYANBG}\e[30m PROJECT ● \e[49m${CYANFG}"
    else
        echo -ne "\e[49m\e[33m"
    fi
}

_INIT_VARIABLES(){
    ISPROJECT=$(find -L ~/Desktop/Projects -xtype l -samefile ${PWD})
    ISBRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1 /')
    local OLDIFS=$IFS
    IFS=$'\n'

    FILES=($(allfiles))
    DIRS=($(alldirs))
    LINKS=($(alllinks))

    IFS=$OLDIFS
}

_PS1_get_info(){
    local EXIT="$?"

    if [[ EXIT -gt 0 ]];
    then
        echo -en "${DEFAULTBG}${REDFG} ✘$EXIT${DEFAULTBG}${WHITEFG}${DEFAULTBG}${WHITEFG}"
    fi

    if (($timer_show > 0));then
        echo -en "${LIGHTCYANFG} sec-${WHITEFG}${timer_show} ${WHITEFG}"
    fi
    
}
