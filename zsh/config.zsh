# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples
#
shell_sources=(~/.config/zsh/.shell_sources/*)

for s in ${shell_sources[@]}; do
    . $s
done

unset shell_sources

# man zshoptions
# setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
# setopt SOURCE_TRACE        # print an informational message announcing the name of each file it loads

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
# bindkey -e                                      # emacs key bindings
bindkey -v                                        # mv key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
HISTORY_IGNORE='([bf]g *|l[alsh]#( *)#|less *| *|gitpass=)'
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt prompt_subst           # for git branch
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# override default virtualenv indicator in prompt
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info() {
    [ $VIRTUAL_ENV ] && echo "(%B%F{reset}$(basename $VIRTUAL_ENV)%b%F{%(#.blue.green)})"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# DISABLE_AUTO_TITLE="true"
# https://superuser.com/questions/735660/whats-the-zsh-equivalent-of-bashs-prompt-command
# precmd() { exec zsh; prompt; }



git_branch_name() {

	local branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')

	if [[ ! $branch == "" ]];then
		# echo ' \e[0;42m  $branch '
		# echo " \e[0;42m  $branch \e[49m"
		# echo " \e[42m  $branch \e[49m"
		echo " \e[42m  $branch \e[49m\e[39m"
	fi
}


if [ "$color_prompt" = yes ]; then

	PROMPT=$'%(?.. %F{red}%? )\e[0;96m[%n%(#.☠.@)%m]%b%F{%(#.blue.green)} %B%F{reset}%(6~.%-1~/…/%4~.%5~)$(git_branch_name)\n%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
	

	# enable syntax-highlighting
	if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
		. /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

		ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
		ZSH_HIGHLIGHT_STYLES[default]=none
		ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[path]=underline
		ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[command-substitution]=none
		ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[process-substitution]=none
		ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[assign]=none
		ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
		ZSH_HIGHLIGHT_STYLES[named-fd]=none
		ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
		ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
		ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
	fi
else
	PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a'
    ;;
*)
    ;;
esac

new_line_before_prompt=no

precmd() {

    FILES=($(allfiles))
    DIRS=($(alldirs))
    LINKS=($(alllinks))

    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$new_line_before_prompt" = yes ]; then
		if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
			_NEW_LINE_BEFORE_PROMPT=1
		else
			print ""
		fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
	if [ $TERM == "eterm-color" ]; then
		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'
	fi
	if [ $TERM == "screen" ]; then
    	ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
	fi
    # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
    # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#'
fi

if [ -f /usr/share/zsh-vim-mode/zsh-vim-mode.plugin.zsh ]; then
	. /usr/share/zsh-vim-mode/zsh-vim-mode.plugin.zsh
	MODE_CURSOR_VICMD="white block"
	MODE_CURSOR_VIINS="#ffffff blinking bar"
	MODE_CURSOR_SEARCH="#ff00ff steady underline"

	zmodload zsh/complist

	bindkey -M menuselect 'h' backward-char
	bindkey -M menuselect 'k' up-line-or-history 
	bindkey -M menuselect 'l' forward-char
	bindkey -M menuselect 'j' down-line-or-history

fi

if [ -f /usr/share/zsh-extract/extract.plugin.zsh ]; then
	. /usr/share/zsh-extract/extract.plugin.zsh
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

if systemctl is-active graphical.target > /dev/null; then
    xset r rate 200 60
fi

export PATH="$PATH:$HOME/bin"
export EDITOR=vim
export HOST="$(echo $HOST)"
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix --hidden --follow --exclude .git'

