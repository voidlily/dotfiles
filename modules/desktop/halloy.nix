{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.halloy = {
    homeManager = {
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
              # TODO make me a secret
              password = "";
              # TODO make me a secret
              #
              # this secret is okay to builtins.readFile, i'm only using it as a
              # "secret" to obfuscate the list of channels i'm in from the world
              #
              # 1. builtins.readFile the secret
              # 2. split on newline, now it's a list
              #
              # limit to no more than 20 or autojoin starts getting rate limited
              channels = [ ];
            };
            liberachat = {
              autoconnect = false;
              server = "irc.libera.chat";
              nickname = "voidlily";
              # TODO make me a secret
              nickname_password = "";
              nick_identify_syntax = "nick-password";
              channels = [ ];
            };
          };
        };
      };

    };
  };
}
