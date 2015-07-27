# -*- mode: shell-script; -*-
# zshenv section moved here because it doesn't work on arch in ~/.zshenv
if [ -f $HOME/.resolution ]; then
    . $HOME/.resolution
fi

export EDITOR=vim

export GOROOT=`go env GOROOT`
export GOPATH=$HOME/go
export NPM_PACKAGES=${HOME}/.npm-packages
path=(
    $HOME/.local/bin
    $HOME/bin
    $path
    $GOPATH/bin
    $NPM_PACKAGES/bin
    $GOROOT/bin
)

export PACMAN="pacmatic"

eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

# fix for gtk3/lxdm
# https://bugs.archlinux.org/task/36427
# may not be needed anymore?
export GDK_CORE_DEVICE_EVENTS=1
# temporary until nvidia fixes the vdpau kernel bug
export VDPAU_NVIDIA_NO_OVERLAY=1
# fix for cheese 3.16
# https://bugs.archlinux.org/task/44531
export CLUTTER_BACKEND=x11

[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"
source "$HOME/dotfiles/antigen/antigen.zsh"

antigen use oh-my-zsh

antigen bundle battery
antigen bundle bgnotify
antigen bundle bower
antigen bundle bundler
antigen bundle colorize
antigen bundle command-not-found
antigen bundle docker
antigen bundle git
antigen bundle heroku
antigen bundle history
antigen bundle lein
antigen bundle mosh
antigen bundle pip
antigen bundle python
antigen bundle rake
antigen bundle rails
antigen bundle rbenv
antigen bundle redis-cli
antigen bundle tmux
antigen bundle virtualenv
antigen bundle virtualenvwrapper

antigen bundle Tarrasch/zsh-autoenv
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

antigen-theme agnoster
antigen-apply

# Show time as well
prompt_context() {
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER@%m"
    prompt_segment green black "%D{%H:%M:%S}"
}

# Only show 2 directory depth
prompt_dir() {
  prompt_segment blue black '%2~'
}

PROMPT="%E
${PROMPT} %E
${SEGMENT_SEPARATOR}"
#  ${RESET}${FG_COLOR_BASE02}${ARROW_SYMBOL}"

# reset
PROMPT="$PROMPT ${RESET} "

# function powerline_precmd() {
#     export PS1="$(~/powerline-shell.py $? --shell zsh 2> /dev/null)"
# }

# function install_powerline_precmd() {
#     for s in "${precmd_functions[@]}"; do
#         if [ "$s" = "powerline_precmd" ]; then
#             return
#         fi
#     done
#     precmd_functions+=(powerline_precmd)
# }

# install_powerline_precmd

# source $HOME/.local/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh
eval `dircolors $HOME/dotfiles/dir_colors`

function chpwd() {
    ls
}

REPORTTIME=1
bgnotify_threshold=5
