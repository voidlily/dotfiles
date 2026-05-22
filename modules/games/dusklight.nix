{
  ...
}:

{
  flake-file.inputs = {
    dusklight = {
      # https://github.com/NixOS/nix/issues/3701#issuecomment-674308574
      # dusklight main broken currently
      url = "git+https://github.com/twilitrealm/dusklight?submodules=1&ref=refs/tags/v1.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.dusklight = {
    nixos =
      { inputs', ... }:
      {
        environment.systemPackages = [
          inputs'.dusklight.packages.default
        ];
      };
  };
}
