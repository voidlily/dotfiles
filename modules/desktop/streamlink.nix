{
  config,
  den,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.streamlink = {
    includes = [ den.aspects.mpv ];
    homeManager =
      { config, ... }:
      {
        programs.streamlink = {
          enable = true;
          settings = {
            player = "${config.programs.mpv.finalPackage}/bin/mpv";
            player-args = "--cache=yes --script-opts='enable-stream-cache-reduction=true'";
            stream-segment-threads = 3;
            ringbuffer-size = "256M";
            default-stream = "best";
            twitch-low-latency = true;
            webbrowser-headless = true;
            # TODO secrets
            twitch-api-header = "";
            twitch-access-token-param = "";
          };
        };
      };
  };
}
