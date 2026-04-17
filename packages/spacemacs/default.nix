# spacemacs.nix
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  inputs,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "spacemacs";
  version = inputs.spacemacs.lastModifiedDate;

  src = fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = inputs.spacemacs.rev;
    hash = inputs.spacemacs.narHash;
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
