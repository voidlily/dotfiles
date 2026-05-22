{ den, ... }:

{
  flake-file.inputs = {
    playdatemirror = {
      url = "github:headblockhead/nix-playdatemirror";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.playdate = {
    includes = [
      (den.batteries.insecure [ "libsoup-2.74.3" ])
    ];
    nixos =
      { inputs', pkgs, ... }:
      {
        environment.systemPackages = [
          (inputs'.playdatemirror.packages.Mirror.overrideAttrs {
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
      };
  };
}
