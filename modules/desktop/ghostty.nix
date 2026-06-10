{
  inputs,
  ...
}:

{
  flake-file.inputs = {
    tinted-terminal = {
      url = "github:tinted-theming/tinted-terminal";
      flake = false;
    };
  };

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
