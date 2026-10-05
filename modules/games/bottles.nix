{ den, ... }:

{
  den.aspects.bottles = {
    includes = [
      (den.batteries.unfree [
        "lsfg-vk"
      ])
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.bottles ];
      };
  };
}
