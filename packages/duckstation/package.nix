{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
let
  pname = "duckstation";
  version = "0.1-12083";
  src = fetchurl {
    url = "https://github.com/stenzek/duckstation/releases/download/v${version}/DuckStation-x64.AppImage";
    hash = "sha256-xebwRfaiQggvyvqfAtVq2JXiM7lCcoeI0jKtDAx2XCQ=";
  };

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast PlayStation 1 emulator for x86-64/AArch32/AArch64/RV64";
    homepage = "https://duckstation.org";
    changelog = "https://github.com/stenzek/duckstation/releases/tag/${version}";
    license = lib.licenses.cc-by-nc-nd-40;
    mainProgram = "duckstation";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };

}
