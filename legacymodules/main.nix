{
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    inputs.flake-parts.flakeModules.modules
    inputs.treefmt-nix.flakeModule
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    # TODO x86_64-darwin going away soon
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
