{ ... }:

{
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
