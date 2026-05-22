{
  inputs,
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  den.default.nixos.imports = [
    inputs.nix-index-database.nixosModules.default
  ];

  den.default.darwin.imports = [
    inputs.nix-index-database.darwinModules.default
  ];

  den.default.homeManager.imports = [
    inputs.nix-index-database.homeModules.default
  ];

  den.aspects.comma = {
    homeManager = {
      programs.nix-index-database.comma.enable = true;
    };
  };
}
