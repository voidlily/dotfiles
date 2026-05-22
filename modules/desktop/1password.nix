{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  # https://wiki.nixos.org/wiki/1Password
  den.aspects._1password = {
    includes = [
      (den.batteries.unfree [
        "1password-cli"
        "1password-gui"
        "1password"
      ])
    ];
    darwin = {
      programs._1password.enable = true;
    };
    nixos = {
      programs._1password.enable = true;
      programs._1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        # TODO put this in my user aspect instead of here?
        # provides.to-users?
        polkitPolicyOwners = [ "lily" ];
      };
    };
  };
}
