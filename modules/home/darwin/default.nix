{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  options.homes.darwin.enable = lib.mkEnableOption "darwin";

  config = lib.mkIf config.homes.darwin.enable {
    home.file = {
      "Library/Application Support/k9s/skins" = {
        recursive = true;
        source = "${inputs.k9s}/skins";
      };
    };
    home.packages = with pkgs; [
      coreutils-prefixed
      # dependencies for emacs/vterm
      cmake
      glibtool
      terminal-notifier
    ];

    programs.doom-emacs = {
      emacs = pkgs.nur.repos.natsukium.emacs-plus;
    };

    services.gpg-agent.pinentry.package = null;
  };
}
