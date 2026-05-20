{ den, inputs, ... }:

# TODO refactor by concern - k9s, gpg-agent-pinentry on linux, etc
{
  den.aspects.homeLinux = {
    homeManager =
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
  };
}
