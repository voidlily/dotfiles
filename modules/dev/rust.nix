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
        cargo-nextest
        cargo-audit
        cargo-mutants
        cargo-deny
        cargo-chef
      ];
    };
  };
}
