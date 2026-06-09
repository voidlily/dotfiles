{
  ...
}:

{
  den.aspects.baobab = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.baobab ];
      };
  };
}
