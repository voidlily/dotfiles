{
  ...
}:

{
  den.aspects.prusa-slicer = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ prusa-slicer ];
      };
  };
}
