{
  den,
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.gpg =
    let
      # TODO move me to a more central location?
      key = "0x3FBFB3CCE12E7D19";
    in
    {
      includes = [ den.aspects.yubikey ];

      homeManager = {

        programs.gpg.enable = true;

        services.gpg-agent = {
          enable = true;
          enableSshSupport = true;
          grabKeyboardAndMouse = false;
          defaultCacheTtl = 86400;
          maxCacheTtl = 86400;
        };

        programs.gpg.scdaemonSettings = {
          disable-ccid = true;
        };

        programs.git.signing = {
          inherit key;
          signByDefault = true;
        };

        programs.jujutsu.settings.signing = {
          behavior = "own";
          backend = "gpg";
          inherit key;
        };
      };
    };
}
