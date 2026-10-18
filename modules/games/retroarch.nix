{
  den,
  ...
}:

{
  den.aspects.retroarch = {
    includes = [
      (den.batteries.unfree [
        "libretro-fbneo"
        "libretro-genesis-plus-gx"
      ])
    ];
    os = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.pcsx2 ];
    };
    homeManager = {
      programs.retroarch = {
        enable = true;
        cores = {
          mgba.enable = true;
          bsnes.enable = true;
          desmume.enable = true;
          genesis-plus-gx.enable = true;
          fbneo.enable = true;
          mesen.enable = true;
          gambatte.enable = true;
        };
      };
    };
  };
}
