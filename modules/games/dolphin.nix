{
  ...
}:

{
  den.aspects.dolphin = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.dolphin-emu
          # doesn't capture mouse
          pkgs.dolphin-emu-primehack
        ];
      };
  };
}
