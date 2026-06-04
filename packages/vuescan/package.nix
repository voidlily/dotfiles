# hamrick does not allow official packaging of vuescan
#
# https://nixos.wiki/wiki/Packaging/Binaries
# https://ryantm.github.io/nixpkgs/hooks/autopatchelf/
#
# because downloading and running a closed source binary on nixos will almost
# never work due to libraries, you have to end up building a minimal package
# anyway with autoPatchelfHook
#
# this is based on the discussion thread at
# https://github.com/NixOS/nixpkgs/issues/217996
{
  lib,
  stdenv,
  fetchurl,
  gnutar,
  autoPatchelfHook,
  glibc,
  gtk3,
  libxkbcommon,
  libsm,
  libgudev,
  undmg,
  udevCheckHook,
  ...
}:
let
  system = stdenv.hostPlatform.system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "vuescan";

  # Minor versions are released using the same file name
  version = "9.8.54";
  versionItems = builtins.splitVersion version;
  versionString = (builtins.elemAt versionItems 0) + (builtins.elemAt versionItems 1);

  src =
    let
      base = "https://www.hamrick.com/files/";
    in
    {
      x86_64-darwin = fetchurl {
        url = "${base}/vuex64${versionString}.dmg";
        sha256 = "1zimcnmyfdqgnc6n1rl8929sill7wfhmvxyfs1q1brmhqyg73fz2";
      };
      x86_64-linux = fetchurl {
        url = "${base}/vuex64${versionString}.tgz";
        sha256 = "sha256-H4TdtVmNMjrHxnKxtmySt8frNtc5HZHjHuC5rSyE/wQ=A";
      };
      aarch64-linux = fetchurl {
        url = "${base}/vuea64${versionString}.tgz";
        sha256 = "1vv97ipb8ps6hlihjcxwh1hamz0yb4vlz59fra6zjkq1vn389m2k";
      };
    }
    .${system} or throwSystem;

  meta = with lib; {
    description = "Scanner software supporting a wide range of devices";
    homepage = "https://hamrick.com/";
    license = licenses.unfree;
    sourceProvenance = lib.binaryNativeCode;
    platforms = [
      # "x86_64-darwin"
      # "aarch64-darwin"
      "x86_64-linux"
      # "aarch64-linux"
    ];
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    # Stripping the binary breaks the license form
    dontStrip = true;

    nativeBuildInputs = [
      gnutar
      autoPatchelfHook
      udevCheckHook
    ];

    buildInputs = [
      glibc
      gtk3
      libxkbcommon
      libsm
      libgudev
    ];

    unpackPhase = ''
      tar xfz $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      install -m755 -D VueScan/vuescan $out/bin/vuescan
      install -m644 -D VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules
      install -m644 -D VueScan/vuescan.svg $out/usr/share/icons/hicolor/scalable/apps
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ undmg ];

    sourceRoot =
      {
        x86_64-darwin = "vuex64${versionString}.dmg";
      }
      .${system} or throwSystem;

    installPhase = ''
      mkdir -p $out/Applications/VueScan.app
      cp -R . $out/Applications/VueScan.app
    '';
  };
in
if stdenv.isDarwin then darwin else linux
