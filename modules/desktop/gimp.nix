{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.gimp = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ gimp ];
      };
  };
}
