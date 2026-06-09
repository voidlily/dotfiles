{
  ...
}:

{
  # https://wiki.nixos.org/wiki/Fcitx5
  den.aspects.input = {
    nixos =
      { pkgs, ... }:
      {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          # looks like this pulls in fcitx5-qt and fcitx5-gtk when using fcitx5-with-addons
          # inputMethod fcitx5 also defaults to fcitx5-with-addons
          # so then the only thing we need is our input method, which is fcitx5-mozc-ut
          fcitx5.addons = with pkgs; [
            fcitx5-mozc-ut
          ];
        };
      };
  };
}
