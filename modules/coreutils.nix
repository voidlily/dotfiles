{
  ...
}:

{
  den.aspects.coreutils = {
    nixos =
      { self', pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          # TODO coreutils or uutils?
          coreutils
          findutils
          diffutils

          colordiff
          killall
          self'.packages.lns
          ripgrep
          ripgrep-all
          fd
          curlFull
          tree
          wget
          xh

          calc
          rink
          yq-go
        ];
        services.locate = {
          enable = true;
          pruneNames = [
            ".bzr"
            ".cache"
            ".git"
            ".hg"
            ".svn"
            ".jj"
          ];
        };
      };
    homeManager =
      { self', pkgs, ... }:
      {
        home.packages = with pkgs; [
          coreutils
          findutils
          diffutils

          colordiff
          killall
          self'.packages.lns
          ripgrep
          ripgrep-all
          fd
          curlFull
          tree
          wget
          xh

          calc
          rink
          yq-go
        ];

        # TODO this is becoming less and less "strict coreutils" and more like
        # shell-minimal, rename?
        programs.atuin = {
          enable = true;
          flags = [
            "--disable-up-arrow"
          ];
          settings = {
            workspaces = true;
          };
        };

        programs.dircolors = {
          enable = true;
        };

        programs.eza = {
          enable = true;
          icons = "auto";
          extraOptions = [ "--hyperlink=auto" ];
        };

        programs.fzf = {
          enable = true;
          historyWidget.command = "";
        };

        programs.home-manager.enable = true;

        programs.jq.enable = true;
        programs.jqp.enable = true;

        programs.zoxide.enable = true;
      };
  };
}
