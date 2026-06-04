{ den, ... }:

{
  den.aspects.playdate = {
    nixos =
      { self', ... }:
      {
        environment.systemPackages = [
          self'.packages.playdatemirror
        ];
      };
    provides.to-users =
      { ... }:
      {
        # if i care enough, limit this by username, otherwise it's available to
        # all users
        #
        # but it's only me so i don't know if i care enough
        user.extraGroups = [ "dialout" ];
      };
  };
}
