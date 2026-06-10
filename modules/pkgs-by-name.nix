{
  inputs,
  ...
}:

{
  flake-file.inputs = {
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
  };
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];
  perSystem.pkgsDirectory = ../packages;
}
