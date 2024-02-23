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
zstyle ':antidote:bundle' use-friendly-names on
source "$HOME/.antidote/antidote.zsh"
source <(antidote init)

antidote bundle zsh-users/zsh-completions
antidote bundle belak/zsh-utils path:completion
antidote bundle ohmyzsh/ohmyzsh path:lib

antidote bundle ohmyzsh/ohmyzsh path:plugins/battery
if [[ $OS -eq 'Linux' && $DISPLAY ]]; then
    antidote bundle ohmyzsh/ohmyzsh path:plugins/bgnotify
elif [[ $OS -eq 'OSX' ]]; then
    if (( $+commands[terminal-notifier] )); then
        # see oh-my-zsh README for explanation of this setting for gnu ls and
        # colors
        zstyle ':omz:lib:theme-and-appearance' gnu-ls yes
        # TODO reenable when
        # https://github.com/julienXX/terminal-notifier/issues/223 is fixed
        antidote bundle ohmyzsh/ohmyzsh path:plugins/bgnotify
    else
        echo 'terminal-notifier not installed, install with `brew install terminal-notifier`'
    fi
fi
antidote bundle ohmyzsh/ohmyzsh path:plugins/asdf
antidote bundle ohmyzsh/ohmyzsh path:plugins/bower
antidote bundle ohmyzsh/ohmyzsh path:plugins/bundler
antidote bundle ohmyzsh/ohmyzsh path:plugins/colorize
antidote bundle ohmyzsh/ohmyzsh path:plugins/command-not-found
antidote bundle ohmyzsh/ohmyzsh path:plugins/docker/completions kind:fpath
antidote bundle ohmyzsh/ohmyzsh path:plugins/git
antidote bundle ohmyzsh/ohmyzsh path:plugins/heroku
antidote bundle ohmyzsh/ohmyzsh path:plugins/history
antidote bundle ohmyzsh/ohmyzsh path:plugins/lein kind:fpath
antidote bundle ohmyzsh/ohmyzsh path:plugins/mosh
antidote bundle ohmyzsh/ohmyzsh path:plugins/pip
antidote bundle ohmyzsh/ohmyzsh path:plugins/python
antidote bundle ohmyzsh/ohmyzsh path:plugins/rake
antidote bundle ohmyzsh/ohmyzsh path:plugins/rbenv
antidote bundle ohmyzsh/ohmyzsh path:plugins/redis-cli kind:fpath
antidote bundle ohmyzsh/ohmyzsh path:plugins/tmux
antidote bundle ohmyzsh/ohmyzsh path:plugins/virtualenv

antidote bundle Tarrasch/zsh-autoenv
antidote bundle zsh-users/zsh-syntax-highlighting
#antidote bundle lukechilds/zsh-nvm
antidote bundle nnao45/zsh-kubectl-completion
antidote bundle mattberther/zsh-pyenv

antidote bundle romkatv/powerlevel10k

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
