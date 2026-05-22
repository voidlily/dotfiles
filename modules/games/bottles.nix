{ ... }:

{
  den.aspects.bottles = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.bottles ];
      };
  };
}
