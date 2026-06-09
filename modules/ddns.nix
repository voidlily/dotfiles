{
  ...
}:

{
  den.aspects.ddns = {
    nixos =
      { config, ... }:
      {
        # TODO maybe move me to a different place or make this parameterizable
        age.secrets = {
          ddns-updater-config = {
            rekeyFile = ../secrets/ddns-updater/config.json.age;
            # don't love this being world readable
            mode = "444";
          };
        };
        services.ddns-updater = {
          enable = true;
          environment = {
            CONFIG_FILEPATH = config.age.secrets.ddns-updater-config.path;
            TZ = config.time.timeZone;
            # picked this port so 8000 and 8080 would be available for other stuff tm
            LISTENING_ADDRESS = ":8053";
          };
        };
      };
  };
}
