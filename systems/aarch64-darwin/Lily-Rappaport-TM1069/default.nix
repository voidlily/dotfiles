{
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [
    "root"
    "lilyrappaport"
  ];

  system.primaryUser = "lilyrappaport";
  nixpkgs.pkgs = pkgs;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.lilyrappaport = {
    home = "/Users/lilyrappaport";
  };
}
