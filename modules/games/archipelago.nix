{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.archipelago = {
    nixos =
      { pkgs, self', ... }:
      {
        environment.systemPackages =
          with pkgs;
          [
            archipelago
            poptracker
          ]
          ++ [
            # can't test this until on the new OS because appimage packages don't work on stanadalone homes
            self'.packages.multiworld-gg
          ];
      };
  };
}
