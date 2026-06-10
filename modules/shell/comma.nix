{
  inputs,
  ...
}:

{
  flake-file.inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
