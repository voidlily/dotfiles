{
  ...
}:
{
  nix.settings.trusted-users = [
    "root"
    "lily"
  ];

  system.primaryUser = "lily";
}
