{
  description = "Home Manager configuration of lily";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      # Optional, to download less. Neither the module nor the overlay uses this input.
      inputs.nixpkgs.follows = "";
    };

    dusklight = {
      url = "git+https://github.com/twilitrealm/dusklight?ref=refs/pull/1237/merge&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    playdatemirror = {
      url = "github:headblockhead/nix-playdatemirror";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    inputs@{
      flake-parts,
      nixpkgs,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          home-manager.flakeModules.home-manager
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          # TODO x86_64-darwin going away soon
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            _module.args.pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
                # mirror neeeds libsoup2, nothing else uses it
                permittedInsecurePackages = [ "libsoup-2.74.3" ];
                nvidia.acceptLicense = true;
              };
              overlays = [ inputs.nur.overlays.default ];
            };
          };
        # Everything pre-flake-parts from snowfall-lib is in here, move it
        flake = {
          homeModules = [
            inputs.nix-index-database.homeModules.default
            inputs.direnv-instant.homeModules.direnv-instant
            inputs.nix-doom-emacs-unstraightened.homeModule
          ];
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
          systems.modules.nixos = with inputs; [
            nix-index-database.nixosModules.default
          ];
          systems.modules.darwin = with inputs; [
            nix-index-database.darwinModules.default
          ];
          homes.modules = with inputs; [
            nix-index-database.homeModules.default
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
    );
}
