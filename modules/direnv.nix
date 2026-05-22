{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  flake-file.inputs = {
    direnv-instant.url = "github:Mic92/direnv-instant";
  };

  den.default.homeManager.imports = [
    inputs.direnv-instant.homeModules.direnv-instant
  ];

  den.aspects.direnv = {
    homeManager = {
      programs.direnv = {
        enable = true;
        # direnv-instant enables direnv, but not nix-direnv
        #
        # it also disables the direnv-specific hooks in favor of direnv-instant's
        # hooks
        nix-direnv.enable = true;
      };

      programs.direnv-instant = {
        enable = true;
      };
    };
  };
}
