{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.firefox = {
    homeManager = {
      programs.firefox = {
        enable = true;
        languagePacks = [ "en-US" ];

        policies = {
          AIControls = {
            Default = "blocked";
            Translations = "available";
          };
        };
      };
    };
  };
}
