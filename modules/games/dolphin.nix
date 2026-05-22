{
  ...
}:

{
  den.aspects.dolphin = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dolphin-emu ];
      };
  };
}
