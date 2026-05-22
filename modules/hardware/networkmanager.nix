{ ... }:
# https://wiki.nixos.org/wiki/NetworkManager
{
  den.aspects.networkmanager = {
    nixos = {
      networking.networkmanager.enable = true;
    };
    provides.to-users =
      { ... }:
      {
        # if i care enough, limit this by username, otherwise it's available to
        # all users
        #
        # but it's only me so i don't know if i care enough
        user.extraGroups = [ "networkmanager" ];
      };
  };
}
