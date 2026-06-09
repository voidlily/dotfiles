{
  ...
}:

{
  den.aspects.jellyfin-web = {
    nixos =
      { pkgs, ... }:
      {
        # jellyfin-desktop is super broken
        # https://wiki.nixos.org/wiki/Jellyfin
        environment.systemPackages = [ pkgs.jellyfin-web ];
      };
  };
}
