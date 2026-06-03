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
          ${self.nixosConfigurations.homu.config.system.build.vm}/bin/run-homu-vm "$@"
        '';
      };
    };
}
