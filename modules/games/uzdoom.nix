{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.uzdoom = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.uzdoom ];
      };
  };
}
