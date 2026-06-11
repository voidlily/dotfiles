{ ... }:

{
  den.aspects.zsh = {
    homeManager = {
      home.shell.enableZshIntegration = true;

      home.sessionVariables = {
        DIRCOLORS_SOLARIZED_ZSH_THEME = "ansi-dark";
        DO_NOT_TRACK = "1";
        EDITOR = "vim";
        REPORTTIME = "1";
        bgnotify_threshold = "30";
        TENV_AUTO_INSTALL = "true";
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
        '';
      };

    };
  };
}
