{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.git = {
    homeManager =
      { pkgs, ... }:
      {
        home.file = {
          # TODO move this file path elsewhere?
          ".config/git/ignore".source = ../../gitignore-global;
        };

        programs.git = {
          enable = true;
          # TODO is this still used? get it into repo?
          includes = [ { path = "~/.config/git/config.local"; } ];
          settings = {
            user = {
              name = "Lily";
              email = "voidlily@users.noreply.github.com";
            };
            # https://dandavison.github.io/delta/merge-conflicts.html
            # https://mergiraf.org/usage.html#enabling-diff3-conflict-style
            merge.conflictStyle = "diff3";
            gist = {
              private = true;
            };
            rebase = {
              autosquash = true;
            };
            rerere = {
              enabled = 1;
            };
            core = {
              excludesfile = "~/.config/git/ignore";
            };
            github = {
              user = "voidlily";
            };
          };
        };

        programs.gh = {
          enable = true;
          gitCredentialHelper = {
            enable = true;
          };
          settings = {
            aliases = {
              co = "pr checkout";
              pv = "pr view";
            };
          };
        };

        programs.git-credential-oauth.enable = true;
      };
  };
}
