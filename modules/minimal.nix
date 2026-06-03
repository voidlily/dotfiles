{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  # minimal barebones things needed for my preferences
  # includes things like shell config, starship, small subset of packages, etc
  den.aspects.minimal = {
    includes = with den.aspects; [
      # agenix is required in minimal to be able to handle secrets
      agenix
      # TODO does this include uutils, rg, xh?
      coreutils
      starship
      # TODO include zoxide? atuin?
      zsh
      # TODO includes home-manager basics, nh, but not nix-dev?
      nix
    ];
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          git
          vim
        ];
      };

    homeManager = {
      home.file = {
        ".vimrc".source = ../vimrc;
      };
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
        };
        flake = "$HOME/dotfiles";
      };
    };
  };
}
