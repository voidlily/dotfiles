{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.imagemagick = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        ghostscript
        imagemagick
      ];
    };
  };
}
