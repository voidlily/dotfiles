{
  ...
}:

{
  den.aspects.zsa = {
    nixos = { pkgs, ... }: {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = [ pkgs.keymapp ];
    };
  };
}
