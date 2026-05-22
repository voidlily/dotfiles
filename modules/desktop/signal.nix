{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.signal = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.signal-desktop ];
      };
  };
}
