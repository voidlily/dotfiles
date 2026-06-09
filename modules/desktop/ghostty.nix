{
  inputs,
  ...
}:

{
  den.aspects.ghostty = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.ghostty ];
      };
    homeManager = {
      programs.ghostty = {
        enable = true;
        settings = {
          theme = "base16-solarized-dark";
          bold-is-bright = false;
        };
        # TODO these should be removed for nixos
        systemd.enable = false;
        package = null;
      };

      home.file = {
        ".config/ghostty/themes" = {
          recursive = true;
          source = "${inputs.tinted-terminal}/themes/ghostty";
        };
      };
    };
  };
}
