{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.dropbox = {
    includes = [
      (den.batteries.unfree [
        "dropbox"
        # dropbox embeds a firefox for login?
        "firefox-bin"
        "firefox-bin-unwrapped"
      ])
    ];
    homeManager =
      { pkgs, ... }:
      {
        systemd.user.services.dropbox = {
          Unit = {
            Description = "Dropbox service";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            ExecStart = "${pkgs.dropbox}/bin/dropbox";
            Restart = "on-failure";
          };
        };
      };
  };
}
