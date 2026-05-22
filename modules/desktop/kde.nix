{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.kde = {
    nixos = {
      services.xserver.enable = true;
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
    };
  };
}
