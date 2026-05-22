{
  den,
  ...
}:

{
  den.aspects.zoom = {
    includes = [ (den.batteries.unfree [ "zoom-us" ]) ];
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ (pkgs.zoom-us.override { plasma6XdgDesktopPortalSupport = true; }) ];
      };
  };
}
