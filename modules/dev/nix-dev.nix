{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.nix-dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          devenv
          nixfmt
          nix-output-monitor
          nix-tree
          nvd
          nixd
          nix-init
        ];
      };
  };
}
