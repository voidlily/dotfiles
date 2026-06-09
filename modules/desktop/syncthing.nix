{
  ...
}:

{
  den.aspects.syncthing = {
    # TODO this is currently setup as a user unit instead of a system unit
    # TODO this won't scale well to multiple hosts, should be elsewhere
    homeManager = {
      services.syncthing = {
        enable = true;
        settings = {
          folders = {
            "~/music" = {
              id = "music";
              type = "sendonly";
              devices = [ "lilys-MacBook-Pro.local" ];
            };
          };
          devices = {
            "lilys-MacBook-Pro.local" = {
              id = "X77YEEP-QVA5FBB-BJEBYH2-KEKTDVN-CA65H5R-LYZG64S-LDJRJVC-JWNEKQD";
            };
          };
        };
      };
    };
  };
}
