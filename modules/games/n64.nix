{ den, ... }:

{
  flake-file.inputs = {
    just-one-more-repo = {
      url = "github:proverbialpennance/just-one-more-repo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.n64 = {
    includes = [
      (den.batteries.unfree [
        "shipwright"
        "2ship2harkinian"
        "starship-sf64"
        "spaghettikart"
        "ghostship"
      ])
    ];
    nixos =
      { pkgs, inputs', ... }:
      {
        environment.systemPackages =
          with pkgs;
          [
            _2ship2harkinian
            shipwright
            spaghettikart
            starship-sf64
            parallel-launcher
          ]
          ++ [ inputs'.just-one-more-repo.packages.ghostship ];
      };
  };
}
