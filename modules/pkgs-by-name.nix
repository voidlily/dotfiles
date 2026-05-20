{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
  perSystem.pkgsDirectory = ../packages;
}
