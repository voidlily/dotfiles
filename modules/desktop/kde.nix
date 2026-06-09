{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.kde = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ wl-clipboard ];
        services.xserver.enable = true;
        services.displayManager.plasma-login-manager.enable = true;
        services.desktopManager.plasma6.enable = true;
      };
  };
}
