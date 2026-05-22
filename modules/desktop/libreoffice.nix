{
  config,
  lib,
  pkgs,
  ...
}:

{
  # https://wiki.nixos.org/wiki/LibreOffice
  den.aspects.libreoffice = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          libreoffice-qt
          hunspell
          hunspellDicts.en-us
          hyphenDicts.en-us
        ];
      };
  };
}
