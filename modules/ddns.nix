{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.ddns = {
    nixos = {
      services.ddns-updater = {
        enable = true;
        environment = {
          # TODO make me a secret
          CONFIG_FILEPATH = "TODO";
        };
      };
    };
  };
}
