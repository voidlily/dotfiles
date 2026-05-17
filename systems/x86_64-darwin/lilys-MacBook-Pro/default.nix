{
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [
    "root"
    "lily"
  ];

  system.primaryUser = "lily";
  nixpkgs.pkgs = pkgs;
  nixpkgs.hostPlatform = "x86_64-darwin";

  users.users.lily = {
    home = "/Users/lily";
  };
}
