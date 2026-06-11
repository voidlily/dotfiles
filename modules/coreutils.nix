{
  ...
}:

{
  den.aspects.coreutils = {
    nixos =
      { self', pkgs, ... }:
      {
        environment.systemPackages = [
          # TODO coreutils or uutils?
          pkgs.coreutils
          pkgs.findutils
          pkgs.diffutils

          pkgs.colordiff
          pkgs.killall
          self'.packages.lns
          pkgs.ripgrep
          pkgs.ripgrep-all
          pkgs.fd
          pkgs.curlFull
          pkgs.tree
          pkgs.wget
          pkgs.xh

          pkgs.rink
          pkgs.yq-go
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
        home.packages = [
          pkgs.coreutils
          pkgs.findutils
          pkgs.diffutils

          pkgs.colordiff
          pkgs.killall
          self'.packages.lns
          pkgs.ripgrep
          pkgs.ripgrep-all
          pkgs.fd
          pkgs.curlFull
          pkgs.tree
          pkgs.wget
          pkgs.xh

          pkgs.rink
          pkgs.yq-go
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
          extraOptions = [ "--hyperlink" ];
        };

        programs.fzf = {
          enable = true;
        };

        programs.home-manager.enable = true;

        programs.jq.enable = true;
        programs.jqp.enable = true;

        programs.zoxide.enable = true;
      };
  };
}
