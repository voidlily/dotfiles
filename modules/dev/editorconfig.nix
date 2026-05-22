{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.editorconfig = {
    homeManager = {
      editorconfig = {
        enable = true;
      };
    };
  };
}
