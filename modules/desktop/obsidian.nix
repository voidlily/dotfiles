{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.obsidian = {
    includes = [
      (den.batteries.unfree [ "obsidian" ])
    ];
    homeManager = {
      programs.obsidian.enable = true;
    };
  };
}
