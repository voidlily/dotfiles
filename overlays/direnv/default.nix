final: prev: {
  # direnv builds fail on darwin due to zsh tests hanging indefinitely
  # tests pass on linux so just disable checkPhase on darwin to get things
  # moving again
  # https://github.com/NixOS/nixpkgs/issues/507531
  # https://github.com/fredsystems/nixos/commit/3ed64d93c707810088fdab968ac00828c0f4af6a
  direnv =
    if prev.stdenv.isDarwin then
      prev.direnv.overrideAttrs (_: {
        doCheck = false;
      })
    else
      prev.direnv;
}
