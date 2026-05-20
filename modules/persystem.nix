{
  inputs,
  self,
  config,
  lib,
  pkgs,
  ...
}:

{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          # this appears necessary to _build_ unfree packages in the same flake
          # (vuescan)
          #
          # TODO would putting vuescan in aspects and exporting via flake
          # options fix needing this? would doing this also save on an
          # evaluation of nixpkgs?
          allowUnfree = true;
          # TODO these options may be unnecessary
          permittedInsecurePackages = [ "libsoup-2.74.3" ];
          nvidia.acceptLicense = true;
        };
        overlays = [
          inputs.nur.overlays.default
        ];
      };
    };
}
