{
  inputs,
  self,
  withSystem,
  ...
}:
let
  system = "x86_64-darwin";
in
{
  flake.darwinConfigurations."lilys-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
    pkgs = withSystem system ({ pkgs, ... }: pkgs);
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-index-database.darwinModules.default
      self.darwinModules.common
      self.modules.darwin."lilys-MacBook-Pro"
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.lily =
          { ... }:
          {
            imports = [
              self.homeModules.homeCommon
              self.homeModules.homeDarwin
              inputs.nix-index-database.homeModules.default
              inputs.direnv-instant.homeModules.direnv-instant
              inputs.nix-doom-emacs-unstraightened.homeModule
            ];
          };
      }
    ];
  };

  flake.modules.darwin."lilys-MacBook-Pro" =
    { ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "lily"
      ];

      system.primaryUser = "lily";
      nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
      nixpkgs.hostPlatform = system;

      users.users.lily = {
        home = "/Users/lily";
      };

    };
}
