# -*- mode: shell-script; -*-
if [ -f $HOME/.resolution ]; then
    . $HOME/.resolution
fi

export EDITOR=vim

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

# https://github.com/elFarto/nvidia-vaapi-driver
export MOZ_DISABLE_RDD_SANDBOX=1
export LIBVA_DRIVER_NAME=nvidia
export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
export NVD_BACKEND=direct

export TENV_AUTO_INSTALL=true
