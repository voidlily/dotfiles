{
  ...
}:

{
  den.aspects.bat = {
    homeManager =
      { pkgs, ... }:
      {
        programs.bat = {
          enable = true;
          config = {
            theme = "Solarized (dark)";
          };
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            # TODO broken - https://github.com/NixOS/nixpkgs/issues/454391
            # batgrep
            batwatch
            prettybat
          ];
        };
      };
  };
}
