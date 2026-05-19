{ inputs, ... }:

{
  flake.homeModules.homeLinux =
    {
      pkgs,
      ...
    }:
    {
      home.file = {
        ".config/k9s/skins" = {
          recursive = true;
          source = "${inputs.k9s}/skins";
        };
      };
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
    };
}
