{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  # https://wiki.nixos.org/wiki/Discord
  den.aspects.discord = {
    includes = [ (den.batteries.unfree [ "discord" ]) ];
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          (discord.override { withTTS = true; })
          # if rich presence is broken try this with arrpc? see wiki
          # arrpc
        ];
        # systemd.packages = with pkgs; [ arrpc ];
      };
  };
}
