{
  lib,
  pkgs,
  stdenvNoCC,
  appimageTools,
  autoPatchelfHook,
  makeWrapper,
  gobject-introspection,
  openssl,
  lttng-ust,
  mtdev,
  xsel,
  xclip,
  zenity,
  fetchurl,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "multiworld-gg";
  version = "0.7.259";
  src = fetchurl {
    url = "https://github.com/MultiworldGG/MultiworldGG/releases/download/${finalAttrs.version}/MultiworldGG_${finalAttrs.version}_linux-x86_64.AppImage";
    hash = "sha256-jkyeJndZxrwnvSVQQ4qKbs760ItVzZSIAHC+cG6uuLQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = finalAttrs.runtimeDependencies;

  runtimeDependencies = [
    gobject-introspection
    lttng-ust
    openssl
  ]
  ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs
  ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  libraryPath = lib.makeLibraryPath [
    mtdev
  ];

  binPath = lib.makeBinPath [
    xsel
    xclip
    zenity
  ];

  appimageContents = appimageTools.extractType2 { inherit (finalAttrs) pname version src; };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${finalAttrs.appimageContents}/AppRun $out/bin/multiworld-gg

    mkdir -p $out/lib/opt
    cp -r ${finalAttrs.appimageContents}/opt/* $out/lib/opt

    wrapProgram $out/bin/multiworld-gg \
      --set APPDIR $out/lib \
      --prefix LD_LIBRARY_PATH : "${finalAttrs.libraryPath}" \
      --prefix PATH : "${finalAttrs.binPath}"

    install -Dm444 ${finalAttrs.appimageContents}/multiworldgg.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/multiworldgg.desktop \
      --replace-fail 'opt/MultiworldGG/MultiworldGG' "multiworldgg"
    cp -r ${finalAttrs.appimageContents}/usr/share/icons $out/share

    runHook postInstall
  '';

  preFixup = ''
    # patchelf \
    #   --replace-needed libcrypto.so.1.0.0 libcrypto.so \
    #   --replace-needed libssl.so.1.0.0 libssl.so \
    #   $out/lib/opt/MultiworldGG/EnemizerCLI/System.Security.Cryptography.Native.OpenSsl.so

    # patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so \
    #   $out/lib/opt/MultiworldGG/EnemizerCLI/libcoreclrtraceptprovider.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Game Randomizer and Server";
    homepage = "https://multiworld.gg";
    changelog = "https://github.com/MultiworldGG/MultiworldGG/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "multiworld-gg";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
