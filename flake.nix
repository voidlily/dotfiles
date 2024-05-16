{
  description = "Home Manager configuration of lily";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      # You must provide our flake inputs to Snowfall Lib.
      inherit inputs;

      # The `src` must be the root of the flake. See configuration
      # in the next section for information on how you can move your
      # Nix files to a separate directory.
      src = ./.;

      channels-config.allowUnfree = true;
    };

  # outputs = { nixpkgs, home-manager, ... }:
  #   let
  #     system = "aarch64-darwin";
  #     pkgs = nixpkgs.legacyPackages.${system};
  #   in {
  #     homeConfigurations."lilymrappaport" =
  #       home-manager.lib.homeManagerConfiguration {
  #         inherit pkgs;

  #         # Specify your home configuration modules here, for example,
  #         # the path to your home.nix.
  #         modules = [ ./home.nix ];

  #         # Optionally use extraSpecialArgs
  #         # to pass through arguments to home.nix
  #       };
  #   };
}
