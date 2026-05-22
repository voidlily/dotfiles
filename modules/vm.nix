{
  config,
  lib,
  pkgs,
  den,
  self,
  ...
}:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.vm = pkgs.writeShellApplication {
        name = "vm";
        text = ''
          # TODO changeme to homu when done?
          ${self.nixosConfigurations.homu2.config.system.build.vm}/bin/run-homu2-vm "$@"
        '';
      };
    };
}
