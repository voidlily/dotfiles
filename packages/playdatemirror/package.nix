{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  udevCheckHook,
  dpkg,
  gtk3,
  webkitgtk_4_1,
  ...
}:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "mirror-${version}";

  src = fetchurl {
    # check against https://download-cdn.panic.com/mirror/Linux/
    # or sometimes https://play.date/mirror/
    # this url changes regularly with each new release
    # sometimes a tar.gz is available, other times only deb and rpm
    # it all depends on the version and can be very finicky at times
    url = "https://download.panic.com/mirror/Linux/Mirror-latest.deb";
    hash = "sha256-CSwMlFarxUJ1/MGXMkfGWIZCmBNy++Y97tZvUm0oS24=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    udevCheckHook
    dpkg
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  installPhase = ''
    runHook preInstall
    cp -r . $out
    install -m755 -D usr/bin/mirror $out/bin/mirror
    install -m644 -D etc/udev/rules.d/50-playdate-mirror.rules $out/lib/udev/rules.d/50-playdate-mirror.rules
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirror is an app that streams gameplay audio and video in real-time from your Playdate to a macOS, Windows, or Linux computer.";
    homepage = "https://play.date/mirror";
    #license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "mirror";
  };
}
