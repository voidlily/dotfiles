{ den, ... }:

{
  den.aspects.n64 = {
    includes = [
      (den.batteries.unfree [
        "shipwright"
        "2ship2harkinian"
        "starship-sf64"
        "spaghettikart"
      ])
    ];
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          _2ship2harkinian
          shipwright
          spaghettikart
          starship-sf64
          parallel-launcher
        ];
      };
  };
}
