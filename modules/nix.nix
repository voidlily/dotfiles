{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.nix = {
    # TODO (after os swap) implement auto-gc (with keep x number of gens on top of previous days)
    os = {
      nix.settings.experimental-features = "nix-command flakes";
      # nix-community maintains a binary cache of unfree but redistributable
      # packages, such as 2ship, 7zip, and steam to name a few
      #
      # https://nix-community.org/package-sets/
      # https://nix-community.org/cache/
      nix.settings.extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      nix.settings.extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      nix.optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };
      nix.settings.auto-optimise-store = true;
    };
  };
}
