# spacemacs.nix
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
let
  rev = "4786a81b5e6a83cd79036ee4b1fea2d207454ca8";
in
stdenvNoCC.mkDerivation {
  pname = "spacemacs";
  version = rev;

  src = fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = rev;
    hash = "sha256-4brFi9Tqn8la39DziwaIiQVSJLErhTHRZdgpihRp98k=";
  };

  patches = [
    # https://szakallas.net/2025/08/02/my-emacs-with-nix-macos/
    # https://github.com/dszakallas/dotfiles-common/blob/530eb5c32df5b6dcb6ec468d07e8300a8330cec7/pkgs/spacemacs/quelpa-build-writable.diff
    ./quelpa-build-writable.diff
  ];

  installPhase = ''
    mkdir -p $out/share/spacemacs
    cp -r * .lock $out/share/spacemacs
  '';
}
