{
  lib,
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
