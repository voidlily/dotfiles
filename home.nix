{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "lily";
  home.homeDirectory = "/home/lily";

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
      size = 10;
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
    # TODO coreutils-prefixed on osx only
    pkgs.coreutils
    # pkgs.coreutils-prefixed
    pkgs.gnupg

    pkgs.nixfmt
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
    ".antidote".source = config.lib.file.mkOutOfStoreSymlink ./antidote;
    ".asdf".source = config.lib.file.mkOutOfStoreSymlink ./asdf;
    ".clojure".source = config.lib.file.mkOutOfStoreSymlink ./clojure;
    ".dircolors".source = ./dir_colors;
    # impure because emacs writes back to cache/elpa/etc dirs in here
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink ./emacs.d;
    ".gemrc".source = ./gemrc;
    ".irbrc".source = ./irbrc;
    ".p10k.zsh".source = ./p10k.zsh;
    ".pryrc".source = ./pryrc;
    # impure because of spacemacs shortcuts <spc> f e D
    ".spacemacs".source = config.lib.file.mkOutOfStoreSymlink ./spacemacs;
    ".terraformrc".source = ./terraformrc;
    ".tmux.conf".source = ./tmux.conf;
    ".vim".source = config.lib.file.mkOutOfStoreSymlink ./vim;
    ".vimrc".source = ./vimrc;
    ".zprofile".source = ./zprofile;
    ".zsh_aliases".source = ./zsh_aliases;
    ".zshenv".source = ./zshenv;
    ".zshrc".source = ./zshrc;
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

  programs.git = {
    enable = true;
    userName = "Lily";
    userEmail = "voidlily@users.noreply.github.com";
    signing = {
      key = "0x3FBFB3CCE12E7D19";
      signByDefault = true;
    };
    extraConfig = {
      gist = { private = true; };
      rebase = { autosquash = true; };
      rerere = { enabled = 1; };
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

  programs.git-credential-oauth.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
