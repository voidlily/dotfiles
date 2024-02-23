# -*- mode: shell-script; -*-

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

UNAME=`uname`

case $UNAME in
    Darwin*)
        OS=OSX
        ;;
    Linux*)
        OS=Linux
        ;;
    *)
        OS=Linux
        ;;
esac

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
    gpg-connect-agent /bye >/dev/null 2>&1
fi

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK_OLD=$SSH_AUTH_SOCK
    case $OS in
        OSX)
            export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
            ;;
        *)
            export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
            ;;
    esac
fi

# Set GPG TTY
GPG_TTY=$(tty)
export GPG_TTY

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

# Updates the GPG-Agent TTY before every command since SSH does not set it.
function _gpg-agent-update-tty {
    gpg-connect-agent UPDATESTARTUPTTY /bye >/dev/null
}
autoload add-zsh-hook
add-zsh-hook preexec _gpg-agent-update-tty

[ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
[ -e "${HOME}/.zshrc_local" ] && source "${HOME}/.zshrc_local"
source "$HOME/dotfiles/antigen/antigen.zsh"

antigen use oh-my-zsh

antigen bundle battery
if [[ $OS -eq 'Linux' && $DISPLAY ]]; then
    antigen bundle bgnotify
elif [[ $OS -eq 'OSX' ]]; then
    if (( $+commands[terminal-notifier] )); then
        # see oh-my-zsh README for explanation of this setting for gnu ls and
        # colors
        zstyle ':omz:lib:theme-and-appearance' gnu-ls yes
        # TODO reenable when
        # https://github.com/julienXX/terminal-notifier/issues/223 is fixed
        antigen bundle bgnotify
    else
        echo 'terminal-notifier not installed, install with `brew install terminal-notifier`'
    fi
fi
antigen bundle asdf
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
antigen bundle rbenv
antigen bundle redis-cli
antigen bundle tmux
antigen bundle virtualenv
antigen bundle virtualenvwrapper

antigen bundle Tarrasch/zsh-autoenv
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting
#antigen bundle lukechilds/zsh-nvm
antigen bundle nnao45/zsh-kubectl-completion
antigen bundle mattberther/zsh-pyenv

antigen theme romkatv/powerlevel10k
antigen apply

export PYENV_ROOT=`pyenv root`

if (($+commands[dircolors])); then
    eval `dircolors $HOME/.dircolors`
fi

function chpwd() {
    ls
}

REPORTTIME=1
bgnotify_threshold=30

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
