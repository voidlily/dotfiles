{
  ...
}:

{
  den.aspects.firefox = {
    homeManager = {
      programs.firefox = {
        enable = true;
        # TODO move .mozilla to the new xdg configpath, then remove this comment when done!
        # configPath = "${config.xdg.configHome}/mozilla/firefox";
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
