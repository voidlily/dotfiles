{
  stdenvNoCC,
  pkgs,
  ...
}:

stdenvNoCC.mkDerivation {
  pname = "lns";
  version = "2.01";
  buildInputs = [
    pkgs.perl
  ];

  src = ./lns;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/lns
    chmod +x $out
    runHook postInstall
  '';
}
