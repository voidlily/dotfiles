{
  config,
  lib,
  pkgs,
  ...
}:

{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ config.agenix-rekey.package ];
        packages = [
          pkgs.age-plugin-yubikey
        ];
      };
    };
}
