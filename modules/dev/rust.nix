{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.rust = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        rustc
        rustfmt
        clippy
        rust-analyzer
        cargo
        bacon
      ];
    };
  };
}
