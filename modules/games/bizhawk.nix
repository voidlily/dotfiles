{
  ...
}:

{
  flake-file.inputs = {
    bizhawk = {
      # TODO change when upstreamed
      url = "github:voidlily/bizhawk/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.bizhawk = {
    os = { inputs', ... }: {
      environment.systemPackages = [ inputs'.bizhawk.packages.emuhawk-latest-bin ];
    };
  };
}
