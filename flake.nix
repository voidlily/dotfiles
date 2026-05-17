{
  description = "Home Manager configuration of lily";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:denful/import-tree";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
      import-tree,
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
          inputs.treefmt-nix.flakeModule
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
              overlays = [
                inputs.nur.overlays.default
                # TODO this doesn't work with import-tree
                (import ./overlays/pack)
                (import ./overlays/direnv)
              ];
            };
            packages.lns = pkgs.callPackage ./packages/lns { };
            packages.stakk = pkgs.callPackage ./packages/stakk { };
            treefmt = {
              programs.nixfmt.enable = true;
            };
          };

        flake =
          let
            common-home-modules = [
              inputs.nix-index-database.homeModules.default
              inputs.direnv-instant.homeModules.direnv-instant
              inputs.nix-doom-emacs-unstraightened.homeModule
            ];
            common-darwin-modules = [ inputs.nix-index-database.darwinModules.default ];
            common-nixos-modules = [ inputs.nix-index-database.nixosModules.default ];
          in
          {
            homeConfigurations."lily@homu" = withSystem "x86_64-linux" (
              {
                pkgs,
                self',
                ...
              }:
              inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = pkgs;
                extraSpecialArgs = { inherit inputs self'; };
                modules = [
                  (import-tree [
                    (./homes/x86_64-linux + "/lily@homu")
                    ./modules/home
                  ])
                  {
                    home.username = "lily";
                    home.homeDirectory = "/home/lily";
                  }
                ]
                ++ common-home-modules;
              }
            );

            darwinConfigurations."Lily-Rappaport-TM1069" = withSystem "aarch64-darwin" (
              { pkgs, self', ... }:
              inputs.nix-darwin.lib.darwinSystem {
                pkgs = pkgs;
                modules = [
                  (import-tree [
                    ./systems/aarch64-darwin/Lily-Rappaport-TM1069
                    ./modules/darwin
                  ])
                  home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = { inherit inputs self'; };
                    home-manager.users.lilyrappaport =
                      { ... }:
                      {
                        imports = [
                          (import-tree [
                            (./homes/aarch64-darwin + "/lilyrappaport@Lily-Rappaport-TM1069")
                            ./modules/home
                          ])
                        ]
                        ++ common-home-modules;
                      };
                  }
                ]
                ++ common-darwin-modules;
              }
            );

            darwinConfigurations."lilys-MacBook-Pro" = withSystem "x86_64-darwin" (
              { pkgs, self', ... }:
              inputs.nix-darwin.lib.darwinSystem {
                pkgs = pkgs;
                modules = [
                  (import-tree [
                    ./systems/x86_64-darwin/lilys-MacBook-Pro
                    ./modules/darwin
                  ])
                  home-manager.darwinModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = { inherit inputs self'; };
                    home-manager.users.lily =
                      { ... }:
                      {
                        imports = [
                          (import-tree [
                            (./homes/x86_64-darwin + "/lily@lilys-MacBook-Pro")
                            ./modules/home
                          ])
                        ]
                        ++ common-home-modules;
                      };
                  }
                ]
                ++ common-darwin-modules;
              }
            );
          };
      }
    );
}
