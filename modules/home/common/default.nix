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

      # nix and dev stuff
      pkgs.devenv
      pkgs.nixfmt-rfc-style
      pkgs.nix-tree
      pkgs.nvd

      # python
      pkgs.mypy
      pkgs.poetry
      pkgs.ruff
      (pkgs.python3.withPackages (ppkgs: [
        ppkgs.boto3
        ppkgs.python-lsp-server
        ppkgs.ruff-lsp
      ]))

      # ruby
      (pkgs.ruby.withPackages (rpkgs: [ rpkgs.solargraph ]))

      # devops
      pkgs.awscli
      pkgs.aws-iam-authenticator
      pkgs.aws-vault
      pkgs.glab
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.kubeswitch
      pkgs.kustomize
      pkgs.nova
      pkgs.pluto
      pkgs.ssm-session-manager-plugin
      pkgs.terraform
      pkgs.terraform-ls
      pkgs.yubikey-manager
      pkgs.yq

      # security
      pkgs.cosign
      pkgs.grype
      pkgs.syft

      # fonts
      pkgs.nerdfonts
      pkgs.dejavu_fonts
      pkgs.material-design-icons
      pkgs.font-awesome
      pkgs.source-sans
      pkgs.source-serif
      pkgs.noto-fonts
    ];

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
      ".antidote".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/antidote";
      ".asdf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/asdf";
      # impure because emacs writes back to cache/elpa/etc dirs in here
      ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/emacs.d";
      # doesn't work on mac, split out to linux specific
      ".vim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/vim";
      # END out of store symlinks

      ".clojure".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/clojure";
      ".dircolors".source = lib.snowfall.fs.get-file "dir_colors";
      ".gemrc".source = lib.snowfall.fs.get-file "gemrc";
      ".irbrc".source = lib.snowfall.fs.get-file "irbrc";
      ".p10k.zsh".source = lib.snowfall.fs.get-file "p10k.zsh";
      ".pryrc".source = lib.snowfall.fs.get-file "pryrc";
      # impure because of spacemacs shortcuts <spc> f e D
      ".spacemacs".source = config.lib.file.mkOutOfStoreSymlink (lib.snowfall.fs.get-file "spacemacs");
      ".tmux.conf".source = lib.snowfall.fs.get-file "tmux.conf";
      ".vimrc".source = lib.snowfall.fs.get-file "vimrc";
      ".zprofile".source = lib.snowfall.fs.get-file "zprofile";
      ".zsh_aliases".source = lib.snowfall.fs.get-file "zsh_aliases";
      ".zshenv".source = lib.snowfall.fs.get-file "zshenv";
      ".zshrc".source = lib.snowfall.fs.get-file "zshrc";
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
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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
      extraConfig = {
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
          excludesfile = "~/.gitignore";
        };
        github = {
          user = "voidlily";
        };
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    # TODO replace antigen with antidote
    # https://getantidote.github.io/migrating-from-antigen
    # homemanager can manage it but may need to migrate most of my zshrc to homemanager instead?

    # TODO https://github.com/srid/nixos-config for example
    # home-manager as flake instead of needing a channel
    # figure out how to separate by host and architecture rather than current modifying on dirty checkout for mac systems

    programs.git-credential-oauth.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.k9s = {
      enable = true;
      settings = {
        k9s = {
          skin = "solarized-16";
        };
      };
      skins = {
        # TODO move this to another file
        solarized-16 = {
          base03 = "gray";
          base02 = "black";
          base01 = "lime";
          base00 = "yellow";
          base0 = "blue";
          base1 = "aqua";
          base2 = "silver";
          base3 = "white";
          yellow = "olive";
          orange = "red";
          red = "maroon";
          magenta = "purple";
          violet = "fuchsia";
          blue = "navy";
          cyan = "teal";
          green = "green";
          background = "default";
          foreground = "yellow";
          current_line = "white";
          selection = "silver";
          comment = "aqua";
          k9s = {
            body = {
              fgColor = "yellow";
              bgColor = "default";
              logoColor = "purple";
            };
            prompt = {
              fgColor = "yellow";
              bgColor = "default";
              suggestColor = "red";
            };
            info = {
              fgColor = "navy";
              sectionColor = "yellow";
            };
            dialog = {
              fgColor = "yellow";
              bgColor = "default";
              buttonFgColor = "yellow";
              buttonBgColor = "purple";
              buttonFocusFgColor = "silver";
              buttonFocusBgColor = "teal";
              labelFgColor = "red";
              fieldFgColor = "yellow";
            };
            frame = {
              border = {
                fgColor = "silver";
                focusColor = "yellow";
              };
              menu = {
                fgColor = "yellow";
                keyColor = "navy";
                numKeyColor = "green";
              };
              crumbs = {
                fgColor = "silver";
                bgColor = "blue";
                activeColor = "navy";
              };
              status = {
                newColor = "yellow";
                modifyColor = "navy";
                addColor = "olive";
                errorColor = "maroon";
                highlightColor = "red";
                killColor = "fuchsia";
                completedColor = "green";
              };
              title = {
                fgColor = "yellow";
                bgColor = "default";
                highlightColor = "navy";
                counterColor = "purple";
                filterColor = "purple";
              };
            };
            views = {
              charts = {
                bgColor = "default";
                defaultDialColors = [
                  "navy"
                  "maroon"
                ];
                defaultChartColors = [
                  "navy"
                  "maroon"
                ];
              };
              table = {
                fgColor = "yellow";
                bgColor = "default";
                cursorFgColor = "silver";
                cursorBgColor = "default";
                markColor = "purple";
                header = {
                  fgColor = "yellow";
                  bgColor = "default";
                  sorterColor = "purple";
                };
              };
              xray = {
                fgColor = "yellow";
                bgColor = "default";
                cursorColor = "white";
                graphicColor = "navy";
                showIcons = false;
              };
              yaml = {
                keyColor = "green";
                colonColor = "black";
                valueColor = "yellow";
              };
              logs = {
                fgColor = "yellow";
                bgColor = "default";
                indicator = {
                  fgColor = "yellow";
                  bgColor = "silver";
                };
              };
            };
          };
        };
        # source: https://github.com/derailed/k9s/blob/master/skins/solarized-dark.yaml
        solarized-dark = {
          foreground = "#839495";
          background = "#002833";
          current_line = "#003440";
          selection = "#003440";
          comment = "#6272a4";
          cyan = "#2aa197";
          green = "#859901";
          orange = "#cb4a16";
          magenta = "#d33582";
          blue = "#2aa198";
          red = "#dc312e";
          k9s = {
            body = {
              fgColor = "#839495";
              bgColor = "#002833";
              logoColor = "#2aa198";
            };
            prompt = {
              fgColor = "#839495";
              bgColor = "#002833";
              suggestColor = "#cb4a16";
            };
            info = {
              fgColor = "#d33582";
              sectionColor = "#839495";
            };
            dialog = {
              fgColor = "#839495";
              bgColor = "#002833";
              buttonFgColor = "#839495";
              buttonBgColor = "#d33582";
              buttonFocusFgColor = "white";
              buttonFocusBgColor = "#2aa197";
              labelFgColor = "#cb4a16";
              fieldFgColor = "#839495";
            };
            frame = {
              border = {
                fgColor = "#003440";
                focusColor = "#003440";
              };
              menu = {
                fgColor = "#839495";
                keyColor = "#d33582";
                numKeyColor = "#d33582";
              };
              crumbs = {
                fgColor = "#839495";
                bgColor = "#003440";
                activeColor = "#003440";
              };
              status = {
                newColor = "#2aa197";
                modifyColor = "#2aa198";
                addColor = "#859901";
                errorColor = "#dc312e";
                highlightColor = "#cb4a16";
                killColor = "#6272a4";
                completedColor = "#6272a4";
              };
              title = {
                fgColor = "#839495";
                bgColor = "#003440";
                highlightColor = "#cb4a16";
                counterColor = "#2aa198";
                filterColor = "#d33582";
              };
            };
            views = {
              charts = {
                bgColor = "default";
                defaultDialColors = [
                  "#2aa198"
                  "#dc312e"
                ];
                defaultChartColors = [
                  "#2aa198"
                  "#dc312e"
                ];
              };
              table = {
                fgColor = "#839495";
                bgColor = "#002833";
                cursorFgColor = "#003440";
                cursorBgColor = "#003440";
                header = {
                  fgColor = "#839495";
                  bgColor = "#002833";
                  sorterColor = "#2aa197";
                };
              };
              xray = {
                fgColor = "#839495";
                bgColor = "#002833";
                cursorColor = "#003440";
                graphicColor = "#2aa198";
                showIcons = false;
              };
              yaml = {
                keyColor = "#d33582";
                colonColor = "#2aa198";
                valueColor = "#839495";
              };
              logs = {
                fgColor = "#839495";
                bgColor = "#002833";
                indicator = {
                  fgColor = "#839495";
                  bgColor = "#003440";
                  toggleOnColor = "#d33582";
                  toggleOffColor = "#2aa198";
                };
              };
            };
          };
        };
      };
    };
  };
}
