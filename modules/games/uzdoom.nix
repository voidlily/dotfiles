{
  ...
}:

{
  den.aspects.uzdoom = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.doomrunner
          pkgs.uzdoom
        ];
      };
  };
}
