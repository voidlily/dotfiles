# -*- mode: shell-script; -*-
if [ -f $HOME/.resolution ]; then
    . $HOME/.resolution
fi

export EDITOR=vim

if (($+commands[go])); then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/go
fi

export NPM_PACKAGES=${HOME}/.npm-packages
export PACMAN="pacmatic"

# fix for gtk3/lxdm
# https://bugs.archlinux.org/task/36427
# may not be needed anymore?
export GDK_CORE_DEVICE_EVENTS=1
# temporary until nvidia fixes the vdpau kernel bug
export VDPAU_NVIDIA_NO_OVERLAY=1
# fix for cheese 3.16
# https://bugs.archlinux.org/task/44531
export CLUTTER_BACKEND=x11
