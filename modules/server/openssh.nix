{ den, ... }:

{
  # TODO import existing host keys?
  # see other notes in agenix about this
  den.aspects.openssh = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
        };
      };
      services.fail2ban.enable = true;
    };
  };
}
