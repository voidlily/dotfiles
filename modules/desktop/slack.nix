{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.slack = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.slack ];
      };
  };
}
