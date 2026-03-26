{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,

  # The namespace used for your flake, defaulting to "internal" if not set.
  namespace,

  # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  rustPlatform,
  fetchCrate,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "1.11.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-vvjd2fRxwZDy4pkbiiJpH9tH23gQhHEt5breDv/v2SI";
  };

  cargoHash = "sha256-xuldQxZopEMR4c2/mkAWhkALwCExyrGfHqfefkq9dCc=";
  doCheck = false;

  meta = {
    description = "stakk bridges Jujutsu bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "stakk";
  };
})
