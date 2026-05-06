{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  options.homes.linux = lib.mkEnableOption "linux";
  config = lib.mkIf config.homes.linux.enable {
    home.file = {
      ".config/k9s/skins" = {
        recursive = true;
        source = "${inputs.k9s}/skins";
      };
    };
    services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
  };
}
