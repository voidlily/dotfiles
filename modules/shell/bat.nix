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
            batgrep
            batwatch
            prettybat
          ];
        };
      };
  };
}
