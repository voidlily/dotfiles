{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "mpv_reduce_stream_cache";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "divout";
    repo = "mpv_reduce_stream_cache";
    rev = "85ddbe54a5e537c1e99ae0face8dadd74bf60758";
    hash = "sha256-FIBZq6dQKEESBzoYKbEKU9AQEaOSQM6iubZh4hSwDeQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/
    cp -r $src/scripts/ $out/share/mpv/
    runHook postInstall
  '';

  passthru.scriptName = "reduce_stream_cache.js";
  meta = {
    description = "Reduces MPV cache for streams by increasing playback speed.";
    homepage = "https://github.com/divout/mpv_reduce_stream_cache";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
