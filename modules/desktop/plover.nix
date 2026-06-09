{
  inputs,
  ...
}:

{
  flake-file.inputs = {
    plover-flake = {
      url = "github:opensteno/plover-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # TODO do i care?
  den.aspects.plover = {
    homeManager =
      { inputs', ... }:
      {
        imports = [ inputs.plover-flake.homeManagerModules.plover ];
        programs.plover = {
          enable = true;
          package = inputs'.plover-flake.packages.plover-full;
        };
      };
  };
}
