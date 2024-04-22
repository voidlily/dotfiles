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

      # devops
      pkgs.awscli
      pkgs.aws-iam-authenticator
      pkgs.aws-vault
      pkgs.glab
      pkgs.kubectl
      pkgs.kustomize
      pkgs.yubikey-manager
      pkgs.yq

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
  };
}
