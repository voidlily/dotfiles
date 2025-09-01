{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  # All other arguments come from the module system.
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.homes.common;
in
{
  options.homes.common = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the common home module.";
    };
  };

  config = mkIf cfg.enable {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    fonts.fontconfig.enable = true;

    gtk = {
      enable = true;
      font = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
        size = 9.5;
      };

      # gtk3 = {
      #   extraConfig = {
      #     gtk-application-prefer-dark-theme = false
      #   };
      # };
    };

    programs.man.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      # coreutils-related
      pkgs.coreutils
      pkgs.gnupg
      pkgs.ispell
      pkgs.ripgrep
      pkgs.wget

      # js
      pkgs.nodejs

      # nix and dev stuff
      pkgs.devenv
      pkgs.meld
      pkgs.nixfmt-rfc-style
      pkgs.nix-tree
      pkgs.nvd

      pkgs.jjui
      inputs.starship-jj.packages.${system}.default

      # python
      pkgs.mypy
      pkgs.uv

      # ruby
      (pkgs.ruby.withPackages (rpkgs: [ rpkgs.solargraph ]))

      # devops
      pkgs.argo-rollouts
      pkgs.awscli2
      pkgs.aws-iam-authenticator
      pkgs.aws-vault
      pkgs.eks-node-viewer
      pkgs.glab
      pkgs.kubectl
      pkgs.kubectl-neat
      pkgs.kubernetes-helm
      pkgs.kubelogin-oidc
      pkgs.kubeseal
      pkgs.kubeswitch
      pkgs.kustomize
      pkgs.markdownlint-cli
      pkgs.nodePackages.prettier
      pkgs.nova
      pkgs.pluto
      pkgs.popeye
      pkgs.ssm-session-manager-plugin
      pkgs.tenv
      pkgs.terraform-docs
      pkgs.terraform-ls
      pkgs.velero
      pkgs.yamllint
      pkgs.yubikey-manager
      pkgs.yq

      # security
      pkgs.cosign
      pkgs.grype
      pkgs.syft

      # fonts
      pkgs.dejavu_fonts
      pkgs.material-design-icons
      pkgs.font-awesome
      pkgs.source-sans
      pkgs.source-serif
      pkgs.noto-fonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      # BEGIN out of store symlinks
      # TODO on new systems, clone spacemacs manually:
      # git clone git@github.com;syl20bnr/spacemacs ~/.config/emacs
      # ".config/emacs" = {
      #   recursive = true;
      #   source = pkgs.fetchFromGitHub {
      #     owner = "syl20bnr";
      #     repo = "spacemacs";
      #     rev = "214de2f3398dd8b7b402ff90802012837b8827a5";
      #     # sha256 = lib.fakeSha256;
      #     sha256 = "a3EkS4tY+VXWqm61PmLnF0Zt94VAsoe5NmubaLPNxhE=";
      #   };
      # };
      # ".config/emacs".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/emacs.d";
      ".config/ghostty/themes" = {
        recursive = true;
        source =
          pkgs.fetchFromGitHub {
            owner = "tinted-theming";
            repo = "tinted-terminal";
            rev = "21ebc0e4ee155280a759779139f0e9b1aed0a530";
            # sha256 = lib.fakeSha256;
            sha256 = "MRJdcdn0gZ/o4hWf9VuZl5UMqe66Ad4YAPTqoKfLJ8Q=";
          }
          + "/themes/ghostty";
      };
      # doesn't work on mac, split out to linux specific
      ".vim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/vim";
      # END out of store symlinks

      ".clojure".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/clojure";
      ".gemrc".source = lib.snowfall.fs.get-file "gemrc";
      ".irbrc".source = lib.snowfall.fs.get-file "irbrc";
      ".p10k.zsh".source = lib.snowfall.fs.get-file "p10k.zsh";
      ".pryrc".source = lib.snowfall.fs.get-file "pryrc";
      # impure because of spacemacs shortcuts <spc> f e D
      ".spacemacs".source = config.lib.file.mkOutOfStoreSymlink (lib.snowfall.fs.get-file "spacemacs");
      ".tmux.conf".source = lib.snowfall.fs.get-file "tmux.conf";
      ".vimrc".source = lib.snowfall.fs.get-file "vimrc";
      ".config/git/ignore".source = lib.snowfall.fs.get-file "gitignore-global";

      ".config/jjui/config.toml".source = lib.snowfall.fs.get-file "jjui-config.toml";
      ".config/starship-jj/starship-jj.toml".source = lib.snowfall.fs.get-file "starship-jj.toml";
    };

    # TODO all the random go binaries in ~/bin get those in nix packages or fetch
    # from github if not packaged or can't figure out how to package

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/lily/etc/profile.d/hm-session-vars.sh
    #
    home.sessionVariables = {
      # EDITOR = "emacs";
      DIRCOLORS_SOLARIZED_ZSH_THEME = "ansi-dark";
      DO_NOT_TRACK = "1";
    };

    home.shell.enableZshIntegration = true;

    programs.atuin = {
      enable = true;
      settings = {
        workspaces = true;
      };
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "Solarized (dark)";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
        prettybat
      ];
    };

    programs.dircolors = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza = {
      enable = true;
      icons = "auto";
      extraOptions = [ "--hyperlink" ];
    };

    programs.git = {
      enable = true;
      userName = "Lily";
      userEmail = "voidlily@users.noreply.github.com";
      signing = {
        key = "0x3FBFB3CCE12E7D19";
        signByDefault = true;
      };
      includes = [ { path = "~/.config/git/config.local"; } ];
      delta = {
        enable = true;
        options = {
          syntax-theme = "Solarized (dark)";
          line-numbers = true;
        };
      };
      extraConfig = {
        # https://dandavison.github.io/delta/merge-conflicts.html
        merge.conflictStyle = "zdiff3";
        gist = {
          private = true;
        };
        rebase = {
          autosquash = true;
        };
        rerere = {
          enabled = 1;
        };
        core = {
          excludesfile = "~/.config/git/ignore";
        };
        github = {
          user = "voidlily";
        };
      };
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    programs.git-credential-oauth.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Lily";
          email = "voidlily@users.noreply.github.com";
        };

        git = {
          private-commits = "bookmarks(exact:'megamerge') | description(glob:'wip:*') | description(glob:'private:*')";
        };

        signing = {
          behavior = "own";
          backend = "gpg";
          key = "0x3FBFB3CCE12E7D19";
        };

        ui = {
          editor = "emacsclient";
          diff-editor = "meld-3";
          merge-editor = "mergiraf";
          diff-formatter = "delta";
          conflict-marker-style = "git";
        };

        merge-tools.delta = {
          # delta exits with 0 if no diff, 1 if diff, 2 if a real error
          # https://jj-vcs.github.io/jj/latest/config/#generating-diffs-by-external-command
          diff-expected-exit-codes = [
            0
            1
          ];
        };

        # https://github.com/jj-vcs/jj/wiki/Fix-tools
        fix.tools.prettier = {
          command = [
            "prettier"
            "--stdin-filepath"
            "$path"
          ];
          patterns = [
            "glob:'**/*.js'"
            "glob:'**/*.jsx'"
            "glob:'**/*.ts'"
            "glob:'**/*.tsx'"
            "glob:'**/*.json'"
            "glob:'**/*.html'"
            "glob:'**/*.md'"
            "glob:'**/*.css'"
            "glob:'**/*.yaml'"
          ];
        };

        fix.tools.ruff = {
          command = [
            "ruff"
            "-"
            "--stdin-filename=$path"
          ];
          patterns = [ "glob:'**/*.py'" ];
        };

        fix.tools.terraform = {
          command = [
            "tofu"
            "fmt"
            "-"
          ];
          patterns = [ "glob:'**/*.tf'" ];
        };

      };
    };

    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          ui = {
            skin = "solarized-dark";
          };
        };
      };
      plugins = {
        # https://github.com/derailed/k9s/blob/master/plugins/argo-rollouts.yaml
        argo-rollouts-get = {
          shortCut = "g";
          confirm = false;
          description = "Get details";
          scopes = [ "rollouts" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "kubectl argo rollouts get rollout $NAME --context $CONTEXT -n $NAMESPACE |& less"
          ];
        };
        argo-rollouts-watch = {
          shortCut = "w";
          confirm = false;
          description = "Watch progress";
          scopes = [ "rollouts" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "kubectl argo rollouts get rollout $NAME --context $CONTEXT -n $NAMESPACE -w |& less"
          ];
        };
        argo-rollouts-promote = {
          shortCut = "p";
          confirm = true;
          description = "Promote";
          scopes = [ "rollouts" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "kubectl argo rollouts promote $NAME --context $CONTEXT -n $NAMESPACE |& less"
          ];
        };
        argo-rollouts-restart = {
          shortCut = "r";
          confirm = true;
          description = "Restart";
          scopes = [ "rollouts" ];
          command = "bash";
          background = false;
          args = [
            "-c"
            "kubectl argo rollouts restart $NAME --context $CONTEXT -n $NAMESPACE |& less"
          ];
        };
        krr = {
          shortCut = "Shift-K";
          confirm = false;
          description = "Get krr";
          scopes = [
            "deployments"
            "statefulsets"
            "daemonsets"
            "rollouts"
          ];
          command = "bash";
          background = false;
          args = [
            "-c"
            ''
              LABELS=$(kubectl get $RESOURCE_NAME $NAME -n $NAMESPACE  --context $CONTEXT  --show-labels | awk '{print $NF}' | awk '{if(NR>1)print}')
              krr simple --cluster $CONTEXT --selector $LABELS
              echo "Press 'q' to exit"
              while : ; do
              read -n 1 k <&1
              if [[ $k = q ]] ; then
              break
              fi
              done
            ''
          ];
        };
      };
    };
    programs.poetry.enable = true;
    programs.ruff.enable = true;
    programs.ruff.settings = { };
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$time"
          "$directory"
          "$git_branch"
          "$git_status"
          "\${custom.jj}"
          # "$c"
          # "$elixir"
          # "$elm"
          # "$golang"
          # "$gradle"
          # "$haskell"
          # "$java"
          # "$julia"
          # "$nodejs"
          # "$nim"
          # "$rust"
          # "$scala"
          # "$docker_context"
          "\${custom.spcr}"
          "$fill"
          "$cmd_duration"
          "$jobs"
          "$line_break"
          "$character"
        ];
        add_newline = true;
        palette = "solarized_dark";
        palettes.solarized_dark = {
          # ansi color order from old theme:
          # base02 red green yellow blue magenta cyan base2
          # base03 orange base01 base00 base0 violet base1 base3
          base03 = "#002b36";
          base02 = "#073642";
          base01 = "#586e75";
          base00 = "#657b83";
          base0 = "#839496";
          base1 = "#93a1a1";
          base2 = "#eee8d5";
          base3 = "#fdf6e3";
          yellow = "#b58900";
          orange = "#cb4b16";
          red = "#dc322f";
          magenta = "#d33682";
          violet = "#6c71c4";
          blue = "#268bd2";
          cyan = "#2aa198";
          green = "#859900";

          # remove these? were using for "character" but can just use the
          # solarized variants for consistency
          strong_green = "#5fd700";
          light_red = "#ff0000";
        };
        username = {
          show_always = true;
          style_user = "bg:base02 fg:base0";
          format = "[ $user@]($style)";
        };
        hostname = {
          ssh_only = false;
          style = "bg:base02 fg:base0";
          format = "[$hostname ]($style)";
        };
        time = {
          disabled = false;
          style = "bg:green fg:base02";
          format = "[ ](fg:prev_bg bg:green)[$time ]($style)";
        };
        directory = {
          fish_style_pwd_dir_length = 2;
          style = "bg:blue fg:base02";
          format = "[ ](fg:prev_bg bg:blue)[$path ]($style)";
        };
        git_branch = {
          style = "bg:yellow fg:base02";
          format = "[ ](fg:prev_bg bg:yellow)[$branch ]($style)";
        };
        git_status = {
          conflicted = "=$count ";
          ahead = "⇡$count ";
          behind = "⇣$count ";
          diverged = "⇕$count ";
          untracked = "?$count ";
          stashed = "*$count ";
          modified = "!$count ";
          staged = "+$count ";
          renamed = "»$count ";
          deleted = "✘$count ";
          style = "bg:yellow fg:base02";
          format = "[$all_status$ahead_behind]($style)";
        };
        custom.spcr = {
          when = true;
          format = "[ ]($style)";
          style = "fg:prev_bg";
        };
        fill = {
          symbol = " ";
        };
        cmd_duration = {
          min_time = 3000;
          style = "bg:yellow fg:base02";
          format = "[ ](bg:prev_bg fg:yellow)[ $duration ]($style)";
        };
        jobs = {
          symbol = "";
          style = "bg:base02 fg:cyan";
          format = "[ ](bg:prev_bg fg:base02)[ $symbol $number ]($style)";
        };
        custom.jj = {
          command = "prompt";
          format = "[ ](fg:prev_bg bg:base03)[$output]()";
          ignore_timeout = true;
          shell = [
            "starship-jj"
            "--ignore-working-copy"
            "starship"
          ];
          use_stdin = false;
          when = true;
        };
      };
    };

    programs.ghostty = {
      enable = true;
      package = null;
      settings = {
        theme = "base16-solarized-dark";
        bold-is-bright = false;
      };
    };

    programs.mergiraf.enable = true;

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
      };
      flake = "$HOME/dotfiles";
    };

    programs.sesh = {
      enable = true;
    };
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
    programs.zoxide.enable = true;

    # programs.tmux = {
    #   enable = true;
    #   baseIndex = 1;
    #   sensibleOnTop = true;
    #   plugins = [
    #     pkgs.tmuxPlugins.sensible
    #     pkgs.tmuxPlugins.resurrect
    #     pkgs.tmuxPlugins.continuum
    #     pkgs.tmuxPlugins.copycat
    #     pkgs.tmuxPlugins.yank
    #     pkgs.tmuxPlugins.open
    #     pkgs.tmuxPlugins.pain-control
    #   ];

    #   extraConfig = ''
    #     set -g @continuum-restore 'on'
    #   '';
    # };

    programs.uv.enable = true;

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
        paru = ''pacman_program="sudo -u #$UID /usr/bin/paru" pacmatic"'';
      };
      initContent = ''
        function chpwd() {
            ls --color
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

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      grabKeyboardAndMouse = false;
      defaultCacheTtl = 86400;
      maxCacheTtl = 86400;
    };
  };
}
