{
  lib,
  ...
}:

{
  den.aspects.jj = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.meld
          pkgs.stakk
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

            # https://ddbeck.com/notes/jj-git-push-bookmark-template/
            template-aliases = {
              "slugify(str)" = ''
                truncate_end(
                65,
                str.first_line()
                  .replace(regex:'[^[[:alnum:]].]', '-')
                  .replace(regex:'-{2,}', '-')
                  .replace(regex:'\.{2,}', '.')
                  .replace(regex:'(^-+|-+$)', ''')
                  .lower()
                  )
              '';
            };

            templates.git_push_bookmark = "slugify(description) ++ \"/\" ++ change_id.short()";

            merge-tools.delta = {
              # delta exits with 0 if no diff, 1 if diff, 2 if a real error
              # https://jj-vcs.github.io/jj/latest/config/#generating-diffs-by-external-command
              diff-expected-exit-codes = [
                0
                1
              ];
            };

            # https://github.com/jj-vcs/jj/wiki/Fix-tools
            fix.tools.dockerfmt = {
              command = [
                (lib.getExe pkgs.dockerfmt)
                "-n"
              ];
              # TODO this might not describe all dockerfiles but it's a start
              patterns = [ "glob:'**/Dockerfile'" ];
            };

            fix.tools.opa = {
              command = [
                (lib.getExe pkgs.open-policy-agent)
                "fmt"
                "-"
              ];
              patterns = [ "glob:'**/*.rego'" ];
            };

            fix.tools.oxfmt = {
              command = [
                (lib.getExe pkgs.oxfmt)
                "--stdin-filepath"
                "$path"
              ];
              # pulled from https://github.com/numtide/treefmt-nix/blob/main/programs/oxfmt.nix
              patterns = [
                "glob:'**/*.cjs'"
                "glob:'**/*.css'"
                "glob:'**/*.graphql'"
                "glob:'**/*.hbs'"
                "glob:'**/*.html'"
                "glob:'**/*.js'"
                "glob:'**/*.json' ~ glob:'**/package-lock.json'"
                "glob:'**/*.json5'"
                "glob:'**/*.jsonc'"
                "glob:'**/*.jsx'"
                "glob:'**/*.md'"
                "glob:'**/*.mdx'"
                "glob:'**/*.mjs'"
                "glob:'**/*.mustache'"
                "glob:'**/*.scss'"
                "glob:'**/*.ts'"
                "glob:'**/*.tsx'"
                "glob:'**/*.vue'"
                "glob:'**/*.yaml'"
                "glob:'**/*.yml'"
              ];
            };

            fix.tools.ruff = {
              command = [
                (lib.getExe pkgs.ruff)
                "format"
                "--stdin-filename=$path"
              ];
              patterns = [ "glob:'**/*.py'" ];
            };

            fix.tools.terraform = {
              command = [
                (lib.getExe pkgs.opentofu)
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
