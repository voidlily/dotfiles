{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem.treefmt = {
    programs.nixfmt.enable = true;
  };
}
