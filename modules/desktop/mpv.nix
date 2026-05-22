{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.mpv = {
    homeManager =
      { pkgs, self', ... }:
      {
        programs.mpv = {
          enable = true;
          config = {
            hwdec = "auto";
          };
          scripts = with pkgs; [
            self'.packages.mpv_reduce_stream_cache
            mpvScripts.builtins.acompressor
            mpvScripts.mpris
          ];
          scriptOpts = {
            reduce_stream_cache = {
              enable_faster_speed_over_cache_seconds = 2.0;
              disable_faster_speed_under_cache_seconds = 1.0;
              faster_speed = 1.015;
              toggle_stream_cache_reduction_shortcut = "a";
            };
          };
        };
      };
  };
}
