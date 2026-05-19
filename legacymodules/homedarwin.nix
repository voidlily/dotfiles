{
  inputs,
  ...
}:

{
  flake.homeModules.homeDarwin =
    { pkgs, ... }:
    {
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
