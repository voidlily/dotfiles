{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.calibre = {
    homeManager = {
      programs.calibre.enable = true;
    };
  };
}
