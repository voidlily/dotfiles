{
  config,
  lib,
  pkgs,
  ...
}:

{
  # https://wiki.nixos.org/wiki/VR
  # https://wiki.vronlinux.org/docs/distros/nixos/#runtimes
  # use monado, do NOT use envision
  den.aspects.vr = {
    homeManager =
      { config, pkgs, ... }:
      {
        xdg.configFile."openxr/1/active_runtime.json".source =
          "${pkgs.monado}/share/openxr/1/openxr_monado.json";

        xdg.configFile."openvr/openvrpaths.vrpath".text = ''
          {
            "config" :
            [
              "${config.xdg.dataHome}/Steam/config"
            ],
            "external_drivers" : null,
            "jsonid" : "vrpathreg",
            "log" :
            [
              "${config.xdg.dataHome}/Steam/logs"
            ],
            "runtime" :
            [
              "${pkgs.opencomposite}/lib/opencomposite"
            ],
            "version" : 1
          }
        '';
      };
    nixos = {
      services.monado = {
        enable = true;
        defaultRuntime = true;
      };
      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };
    };
  };
}
