{ ... }:

{
  den.aspects.zsh = {
    homeManager = {
      home.shell.enableZshIntegration = true;

      home.sessionVariables = {
        DIRCOLORS_SOLARIZED_ZSH_THEME = "ansi-dark";
        DO_NOT_TRACK = "1";
      };

      programs.zsh = {
        enable = true;
        antidote = {
          enable = true;
          plugins = [
            "mattmc3/ez-compinit"
            # TODO evaluate which ones are still needed
            "zsh-users/zsh-completions"
            "belak/zsh-utils path:completion"

            "getantidote/use-omz"
            "ohmyzsh/ohmyzsh path:lib"

            "ohmyzsh/ohmyzsh path:plugins/bgnotify"

            "ohmyzsh/ohmyzsh path:plugins/brew"
            "ohmyzsh/ohmyzsh path:plugins/bundler"
            # "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
            "ohmyzsh/ohmyzsh path:plugins/command-not-found"

            "zsh-users/zsh-syntax-highlighting"
            "pinelibg/dircolors-solarized-zsh"
            # doesn't work?
            # "olets/zsh-transient-prompt"
          ];
        };
        shellAliases = {
          df = "df -h";
          du = "du -h";
          pgrep = "pgrep -l";
          diff = "colordiff";
          gthumb = "nomacs";
          mplayer = "mpv";
          calc = "noglob calc";
          pacmatic = "sudo --preserve-env=pacman_program /usr/bin/pacmatic";
          paru = ''pacman_program="sudo -u #$UID /usr/bin/paru" pacmatic'';
        };
        initContent = ''
          function chpwd() {
              eza --icons auto --hyperlink
          }

          function streamlink-twitch() {
              streamlink -p mpv "https://twitch.tv/$1" best
          }

          function calc() {
              noglob awk "BEGIN{ print $* }";
          }

          REPORTTIME=1
          bgnotify_threshold=30
        '';
        # TODO move all this up to sessionVariables
        envExtra = ''
          if [ -f $HOME/.resolution ]; then
              . $HOME/.resolution
          fi

          export EDITOR=vim

          export NPM_PACKAGES="$HOME/.npm-packages"
          export PACMAN="pacmatic"

          # fix for gtk3/lxdm
          # https://bugs.archlinux.org/task/36427
          # may not be needed anymore?
          export GDK_CORE_DEVICE_EVENTS=1
          # temporary until nvidia fixes the vdpau kernel bug
          export VDPAU_NVIDIA_NO_OVERLAY=1
          # fix for cheese 3.16
          # https://bugs.archlinux.org/task/44531
          #export CLUTTER_BACKEND=x11

          # https://github.com/elFarto/nvidia-vaapi-driver
          export MOZ_DISABLE_RDD_SANDBOX=1
          export LIBVA_DRIVER_NAME=nvidia
          export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
          export NVD_BACKEND=direct

          export TENV_AUTO_INSTALL=true
        '';
      };

    };
  };
}
