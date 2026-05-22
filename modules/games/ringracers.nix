{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.ringracers = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.ringracers ];
      };
  };
}
