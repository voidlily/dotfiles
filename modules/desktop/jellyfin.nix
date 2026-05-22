{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.jellyfin-web = {
    nixos = {
      # jellyfin-desktop is super broken
      # https://wiki.nixos.org/wiki/Jellyfin
      environment.systemPackages = [ pkgs.jellyfin-web ];
    };
  };
}
