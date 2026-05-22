{
  den,
  lib,
  ...
}:

{
  # https://wiki.nixos.org/wiki/Fonts
  den.aspects.fonts = {
    includes = [
      (den.batteries.unfree [
        "corefonts"
        "symbola"
      ])
    ];
    nixos =
      { pkgs, ... }:
      {
        fonts.enableDefaultPackages = true;

        environment.systemPackages = [
          pkgs.dejavu_fonts
          pkgs.material-design-icons
          pkgs.font-awesome
          pkgs.source-sans
          pkgs.source-serif
          pkgs.noto-fonts

          # legacy windows fonts
          pkgs.corefonts

          # symbola needed for doom emacs as a fallback
          pkgs.symbola
        ]
        ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      };
    homeManager =
      { pkgs, ... }:
      {
        fonts.fontconfig.enable = true;

        home.packages = [
          pkgs.dejavu_fonts
          pkgs.material-design-icons
          pkgs.font-awesome
          pkgs.source-sans
          pkgs.source-serif
          pkgs.noto-fonts

          # legacy windows fonts
          pkgs.corefonts

          # symbola needed for doom emacs as a fallback
          pkgs.symbola
        ]
        ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

        # TODO look at
        # https://github.com/ryan4yin/nix-config/blob/b047c064d64ac5858128e944e77cc59de407a7a5/modules/nixos/desktop/fonts.nix#L2
        # for default fonts like color emoji fonts
      };
  };
}
