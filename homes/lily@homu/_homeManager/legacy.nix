{
  inputs,
  self,
  withSystem,
  ...
}:

{
  flake.homeConfigurations."lily@homu" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);

    modules = [
      self.homeModules.homeCommon
      self.homeModules.homeLinux
      self.homeModules.homuPackages
      inputs.nix-index-database.homeModules.default
      inputs.direnv-instant.homeModules.direnv-instant
      inputs.nix-doom-emacs-unstraightened.homeModule
      {
        home.username = "lily";
        home.homeDirectory = "/home/lily";
      }
    ];
  };
}
