{
  ...
}:

{
  den.aspects.ringracers = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.ringracers ];
      };
  };
}
