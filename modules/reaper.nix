{ den, inputs, ... }:

{
  flake-file.inputs.reaper-flake = {
    url = "github:9prestidigitator/reaper-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  den.default.homeManager.imports = [
    inputs.reaper-flake.homeModules.reaper
  ];

  den.aspects.reaper = {
    includes = [
      (den.batteries.unfree [
        "reaper"
        "reaper-config-wrapper"
        "vcv-rack"
        "vital"
      ])
    ];
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        # does this even need carla
        carla
        vcv-rack
        # vst
        surge-xt
        vital
        # windows vst support
        # use bottles to install them?
        yabridge
        yabridgectl
      ];
    };
    homeManager = { pkgs, ... }: {
      programs.reaper = {
        enable = true;
        packages = with pkgs; [
          freetype
          libpng
          zlib
          fontconfig
          libepoxy
          gtk3
          cairo
          glib
        ];
        extensions = {
          reapack.enable = true;
          sws = {
            enable = true;
            colors = [
              "#F5E0E6"
              "#F2CDCD"
              "#F5C2E7"
              "#CBA6F7"
            ];
          };
        };

        preferences = {
          general.startupSettings.showSplashScreenOnStartup = false;
          project.trackSendDefaults.trackVolumeFaderGain = -10.0;
          plugIns.reascript.python.enable = true;
        };
      };
    };
  };
}
