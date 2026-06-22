{
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

          sops
          kustomize-sops
          rage
        ];

        services.pcscd.enable = true;
      };
  };
}
