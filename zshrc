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
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

antigen-theme steeef
antigen-apply

REPORTTIME=1
bgnotify_threshold=5
