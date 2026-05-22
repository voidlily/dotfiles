{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.homestuck = {
    os = {
      environment.systemPackages = [ pkgs.unofficial-homestuck-collection ];
    };
  };
}
