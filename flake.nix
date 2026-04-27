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

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    direnv-instant.url = "github:Mic92/direnv-instant";

    # non-flake inputs that were previously submodules pre-nix
    spacemacs = {
      url = "github:syl20bnr/spacemacs";
      flake = false;
    };

    k9s = {
      url = "github:derailed/k9s";
      flake = false;
    };

    tinted-terminal = {
      url = "github:tinted-theming/tinted-terminal";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        # You must provide our flake inputs to Snowfall Lib.
        inherit inputs;

        # The `src` must be the root of the flake. See configuration
        # in the next section for information on how you can move your
        # Nix files to a separate directory.
        src = ./.;

      };
    in
    lib.mkFlake {
      channels-config.allowUnfree = true;
      outputs-builder =
        channels:
        let
          treefmtEval = inputs.treefmt-nix.lib.evalModule channels.nixpkgs {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };
        in
        {
          formatter = treefmtEval.config.build.wrapper;
          checks = {
            treefmt = treefmtEval.config.build.check ./.;
          };
        };
      overlays = with inputs; [
        nur.overlays.default
      ];
      systems.modules.nixos = with inputs; [
        nix-index-database.nixosModules.default
      ];
      systems.modules.darwin = with inputs; [
        nix-index-database.darwinModules.default
      ];
      homes.modules = with inputs; [
        nix-index-database.homeModules.default
        direnv-instant.homeModules.direnv-instant
      ];
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
