# -*- mode: shell-script; -*-
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

#POWERLINE_RIGHT_A="exit-status"
#POWERLINE_FULL_CURRENT_PATH=1
#antigen-theme jeremyFreeAgent/oh-my-zsh-powerline-theme powerline
ZSH_POWERLINE_SHOW_OS=false
antigen-theme KuoE0/oh-my-zsh-solarized-powerline-theme solarized-powerline
antigen-apply

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
