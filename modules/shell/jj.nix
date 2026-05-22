{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.jj = {
    homeManager =
      { self', pkgs, ... }:
      {
        home.packages = [
          pkgs.meld
          self'.packages.stakk
        ];

        programs.delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            syntax-theme = "Solarized (dark)";
            line-numbers = true;
          };
        };

        programs.mergiraf = {
          enable = true;
          enableGitIntegration = true;
          enableJujutsuIntegration = true;
        };

        programs.jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "Lily";
              email = "voidlily@users.noreply.github.com";
            };

            git = {
              private-commits = "bookmarks(exact:'megamerge') | description(glob:'wip:*') | description(glob:'private:*')";
            };

            ui = {
              editor = "emacsclient";
              diff-editor = "meld-3";
              diff-formatter = "delta";
              conflict-marker-style = "git";
            };

            merge-tools.delta = {
              # delta exits with 0 if no diff, 1 if diff, 2 if a real error
              # https://jj-vcs.github.io/jj/latest/config/#generating-diffs-by-external-command
              diff-expected-exit-codes = [
                0
                1
              ];
            };

            # https://github.com/jj-vcs/jj/wiki/Fix-tools
            fix.tools.opa = {
              command = [
                "opa"
                "fmt"
                "-"
              ];
              patterns = [ "glob:'**/*.rego'" ];
            };

            fix.tools.prettier = {
              command = [
                "${pkgs.prettier}/bin/prettier"
                "--stdin-filepath"
                "$path"
              ];
              patterns = [
                "glob:'**/*.js'"
                "glob:'**/*.jsx'"
                "glob:'**/*.ts'"
                "glob:'**/*.tsx'"
                "glob:'**/*.json'"
                "glob:'**/*.html'"
                "glob:'**/*.md'"
                "glob:'**/*.css'"
                "glob:'**/*.yaml'"
              ];
            };

            fix.tools.ruff = {
              command = [
                "${pkgs.ruff}/bin/ruff"
                "format"
                "--stdin-filename=$path"
              ];
              patterns = [ "glob:'**/*.py'" ];
            };

            fix.tools.terraform = {
              command = [
                "${pkgs.opentofu}/bin/tofu"
                "fmt"
                "-"
              ];
              patterns = [ "glob:'**/*.tf'" ];
            };
          };
        };

        programs.jjui = {
          enable = true;
          settings = {
            actions = [
              {
                name = "megamerge.add";
                lua = ''
                  jj_async("rebase", "-r", context.change_id(), "-A", "trunk()", "-B", "megamerge")
                  revisions.refresh()
                '';
              }
              {
                name = "megamerge.remove";
                lua = ''
                  jj_async("rebase", "-s", "megamerge", "-d", "megamerge- ~" .. context.change_id())
                  revisions.refresh()
                '';
              }
              {
                name = "rebase-all";
                lua = ''
                  jj_async("rebase", "-b", "megamerge", "-d", "trunk()")
                  revisions.refresh()
                '';
              }
              {
                name = "new-main";
                lua = ''
                  jj_async("new", "trunk()")
                  revisions.refresh()
                '';
              }
              {
                name = "resolve-mergiraf";
                lua = ''
                  jj_async("resolve", "--tool", "mergiraf", "-r", context.change_id())
                  revisions.refresh()
                '';
              }
              {
                name = "fix";
                lua = ''
                  jj_async("fix")
                  revisions.refresh()
                '';
              }
            ];
            bindings = [
              {
                action = "resolve-mergiraf";
                key = "V";
                scope = "revisions";
                desc = "resolve mergiraf";
              }
              {
                action = "fix";
                key = "F";
                scope = "revisions";
                desc = "fix";
              }
              {
                action = "megamerge.add";
                seq = [
                  "x"
                  "a"
                ];
                scope = "revisions";
                desc = "add to megamerge";

              }
              {
                action = "megamerge.remove";
                seq = [
                  "x"
                  "d"
                ];
                scope = "revisions";
                desc = "remove from megamerge";
              }
              {
                action = "rebase-all";
                seq = [
                  "x"
                  "r"
                ];
                scope = "revisions";
                desc = "rebase all";
              }
            ];
          };
        };
      };
  };
}
