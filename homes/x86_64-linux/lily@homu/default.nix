{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,

  # Additional metadata is provided by Snowfall Lib.
  home, # The home architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
  format, # A normalized name for the home target (eg. `home`).
  virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
  host, # The host name for this home.

  # All other arguments come from the home home.
  config,
  ...
}:
{
  # Your configuration.
  config.homes.common.enable = true;
  config.homes.linux.enable = true;

  config.targets.genericLinux = {
    # enable genericLinux things to better run on non-nixos
    enable = true;
    gpu.nvidia = {
      enable = true;
      # nvidia driver version must match host driver version
      version = "590.48.01";
      sha256 = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
    };
  };

  config.home.packages = [
    inputs.dusklight.packages.x86_64-linux.default
    pkgs.shipwright
    pkgs._2ship2harkinian
    pkgs.starship-sf64
    pkgs.spaghettikart
    (inputs.playdatemirror.packages.x86_64-linux.Mirror.overrideAttrs {
      buildInputs = with pkgs; [
        gtk3
        # webkitgtk abi4.0
        (webkitgtk_4_1.overrideAttrs (
          final: prev: {
            # last version to support abi 4.0
            version = "2.50.6";
            name = "webkitgtk-${final.version}+abi=4.0";
            src = fetchurl {
              url = "https://webkitgtk.org/releases/webkitgtk-${final.version}.tar.xz";
              hash = "sha256-Kygav4iU/8YXIVLlZgt17u7b4cxD1ng9Cdx598hlu0I=";
            };
            buildInputs = prev.buildInputs ++ [ pkgs.woff2 ];
            propagatedBuildInputs = [
              pkgs.gtk4
              pkgs.gtk3
              # libsoup_2_4 is insecure, requires permittedInsecurePackages to
              # build
              pkgs.libsoup_2_4
            ];
            cmakeFlags = prev.cmakeFlags ++ [
              "-DUSE_SOUP2=ON"
            ];
          }
        ))
      ];
    })
  ];
}
