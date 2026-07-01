{ den, ... }:

{
  den.aspects.shell-full = {
    includes = with den.aspects; [
      minimal
      emacs
      # # TODO does not include nix, nh, etc?
      nix-dev
      git
      jj
      # # TODO is ruff, uv, etc part of python?
      # python
      # ruby
      linters
      rust
      # # TODO split up "devops" in homecommon by concern more - aws, gcp, etc
      # devops
      opentofu
      k8s
      # security
      # clojure
      # zellij
      # vim
      # atuin
      bat
      direnv
      comma
      imagemagick
    ];
  };
}
