{ inputs, ... }:
{
  # TODO split out inputs as necessary
  # like for example dusklight input should live in the module that installs dusklight
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    den.url = "github:denful/den";
    import-tree.url = "github:denful/import-tree";
    flake-file.url = "github:denful/flake-file";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-file.flakeModules.nix-auto-follow
  ];
}
