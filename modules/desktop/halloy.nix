{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.halloy = {
    # TODO this _works_, but should really be on the user instead of the host so
    # changes to the config don't require an os rebuild
    os = {
      age.secrets = {
        irc-password-liberachat = {
          rekeyFile = ../../secrets/irc/password-liberachat.age;
        };
        irc-channels-twitch = {
          rekeyFile = ../../secrets/irc/channels-twitch.age;
        };
        irc-password-twitch = {
          rekeyFile = ../../secrets/irc/password-twitch.age;
        };
      };
    };
    homeManager =
      { osConfig, ... }:
      {
        programs.halloy = {
          enable = true;
          settings = {
            scale_factor = 1.0;
            font = {
              family = "Monospace";
              size = 15;
            };

            buffer = {
              text_input = {
                # auto_format = "all";
                autocomplete.completion_suffixes = [
                  " "
                  " "
                ];
                nickname.enabled = false;
              };

              channel.nicklist.enabled = false;

              nickname = {
                alignment = "left";
                color = "unique";
                offline = "none";
                # truncate = 10;
              };

              timestamp = {
                format = "%T";
                brackets = {
                  left = "[";
                  right = "]";
                };
              };

              server_messages = {
                join.exclude = [ "*" ];
                part.exclude = [ "*" ];
              };
            };

            actions.sidebar = {
              buffer = "replace-pane";
              focused_buffer = "close-pane";
            };

            sidebar = {
              max_width = 125;
            };

            servers = {
              twitch = {
                autoconnect = true;
                server = "irc.chat.twitch.tv";
                on_connect = [
                  "/raw CAP REQ :twitch.tv/membership"
                ];
                nickname = "void_lily";
                # TODO put my actual value in
                password_file = osConfig.age.secrets.irc-password-twitch.path;
                # this secret is okay to builtins.readFile, i'm only using it as a
                # "secret" to obfuscate the list of channels i'm in from the world
                #
                # 1. builtins.readFile the secret
                # 2. split on newline, now it's a list
                #
                # limit to no more than 20 or autojoin starts getting rate limited
                # channels = lib.strings.splitString "\n" (
                #   # TODO this doesn't seem to work, like at all
                #   # the assumption is flawed and agenix only supports password file refs
                #   # the equivalent of
                #   # passwordFile = /run/agenix/secrets/irc-password-twitch
                #   #
                #   # so reading it at build time is just flat out of the question
                #   #
                #   # TODO the other approach is just put the whole toml file as a secret instead of using settings option
                #   # https://github.com/nix-community/home-manager/blob/release-26.05/modules/programs/halloy.nix
                #   builtins.readFile osConfig.age.secrets.irc-channels-twitch.path
                # );
              };
              liberachat = {
                autoconnect = false;
                server = "irc.libera.chat";
                nickname = "voidlily";
                # TODO put my actual values in
                nick_password_file = osConfig.age.secrets.irc-password-liberachat.path;
                nick_identify_syntax = "nick-password";
                channels = [ ];
              };
            };
          };
        };
      };
  };
}
