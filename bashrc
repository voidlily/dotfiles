# -*- mode: shell-script; -*-
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Comment in the above and uncomment this below for a color prompt
PS1='\[\033[01;34m\][\t]\[\033[01;32m\]\u@\h\[\033[00m\]:$(__git_ps1 "\[\e[32m\](%s)\[\e[0m\]:")\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias ls='ls --color=auto --group-directories-first'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi

# some more ls aliases
alias LS='ls'
alias sl='ls'
alias dc='cd'
alias s='ls'
alias pign='ping'
alias ll='ls -l'
alias la='ls -A'
alias lal='ls -Al'
alias lla='lal'
alias l='ls -CF'
alias l.='ls -d .*'
alias cd..='cd ..'
alias ull='ULL'
alias more='less'
alias mroe='more'

alias igrep='grep -i'
alias df='df -h'
alias du='du -h'
alias update='sudo aptitude update'
alias pgrep='pgrep -l'
alias dist-upgrade='sudo aptitude dist-upgrade'
alias install='sudo aptitude install'
alias instal='install'
alias remove='sudo aptitude remove'
alias purge='sudo aptitude purge'
alias search='aptitude search'
alias show='aptitude show'
alias showv='aptitude -v show'
alias diff='colordiff'
alias pgrpe='pgrep'
alias vmwarefix='setxkbmap'
alias unraw='sudo kbd_mode -u'
alias grpe='grep'
alias woot='telnet zerocarbs.wooters.us'

alias ldp='LD_PRELOAD=/usr/lib32/nvidia-current/libGL.so'

#alias gtk-redshift-myloc='gtk-redshift -l 33.781538:-84.399097 -t 5700:4900'
alias gtk-redshift-myloc='gtk-redshift -l 33.781538:-84.399097 -t 5700:4500'
alias redshift-gtk-myloc='redshift-gtk -l 33.781538:-84.399097 -t 5700:4500'
#alias gtk-redshift-myloc='gtk-redshift -l 33.781538:-84.399097'
alias gtk-redshift-myloc-ca='gtk-redshift -l 37.619720:-122.364723 -t 5700:4900'
alias redshift-gtk-myloc-ca='redshift-gtk -l 37.619720:-122.364723 -t 5700:4900'
alias pisg='$HOME/src/pisg/pisg'
alias skype='PULSE_LATENCY_MSEC=60 skype'
alias praat='PULSE_LATENCY_MSEC=60 praat'
alias gthumb='nomacs'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f $HOME/.resolution ]; then
    . $HOME/.resolution
fi

export EDITOR=vim

calc(){ awk "BEGIN{ print $* }" ;}

export GOROOT=`go env GOROOT`
export GOPATH=$HOME/go
export NPM_PACKAGES=${HOME}/.npm-packages

export PATH=${PATH}:${GOPATH}/bin:${GOROOT}/bin:/sbin:/usr/sbin:${NPM_PACKAGES}/bin

export PACMAN="pacmatic"

# fix for gtk3/lxdm
# https://bugs.archlinux.org/task/36427
# may not be needed anymore?
export GDK_CORE_DEVICE_EVENTS=1
# fix for cheese 3.16
# https://bugs.archlinux.org/task/44531
export CLUTTER_BACKEND=x11

eval `dircolors $HOME/dotfiles/dir_colors`
