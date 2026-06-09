{
  ...
}:

{
  den.aspects.signal = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.signal-desktop ];
      };
  };
}
