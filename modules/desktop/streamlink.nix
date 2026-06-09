{
  den,
  ...
}:

{
  den.aspects.streamlink = {
    includes = [ den.aspects.mpv ];
    os = {
      age.secrets = {
        "streamlink.conf" = {
          rekeyFile = ../../secrets/streamlink.conf.age;
          path = "/home/lily/.config/streamlink/config";
          owner = "lily";
        };
      };
    };
    homeManager =
      { ... }:
      {
        programs.streamlink = {
          enable = true;
        };
      };
  };
}
