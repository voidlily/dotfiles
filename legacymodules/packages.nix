{
  inputs,
  self,
  withSystem,
  ...
}:

{
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # mirror neeeds libsoup2, nothing else uses it
          permittedInsecurePackages = [ "libsoup-2.74.3" ];
          nvidia.acceptLicense = true;
        };
        overlays = [
          inputs.nur.overlays.default
          # TODO this doesn't work with import-tree
          (import ../overlays/pack)
          (import ../overlays/direnv)
          self.overlays.default
        ];
      };
      pkgsDirectory = ../packages;
      treefmt = {
        programs.nixfmt.enable = true;
      };
    };
  flake.overlays.default = final: prev: {
    local = withSystem prev.stdenv.hostPlatform.system ({ config, ... }: config.packages);
  };
}
