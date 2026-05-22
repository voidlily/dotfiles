{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.yubikey = {
    nixos =
      { pkgs, ... }:
      {
        programs.yubikey-manager.enable = true;

        environment.systemPackages = with pkgs; [
          age-plugin-yubikey
          yubioath-flutter
          opensc
        ];

        services.pcscd.enable = true;
      };
  };
}
