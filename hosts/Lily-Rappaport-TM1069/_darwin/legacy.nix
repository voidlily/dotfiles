{
  inputs,
  self,
  withSystem,
  ...
}:
let
  system = "aarch64-darwin";
in
{
  flake.darwinConfigurations."Lily-Rappaport-TM1069" = inputs.darwin.lib.darwinSystem {
    pkgs = withSystem system ({ pkgs, ... }: pkgs);
    modules = [
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-index-database.darwinModules.default
      self.darwinModules.common
      self.modules.darwin."Lily-Rappaport-TM1069"
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.lilyrappaport =
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

  flake.modules.darwin."Lily-Rappaport-TM1069" =
    { ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "lilyrappaport"
      ];

      system.primaryUser = "lilyrappaport";
      nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
      nixpkgs.hostPlatform = system;

      users.users.lilyrappaport = {
        home = "/Users/lilyrappaport";
      };
    };
}
