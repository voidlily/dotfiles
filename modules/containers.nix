{
  lib,
  ...
}:

{
  den.aspects.containers = {
    nixos =
      { pkgs, ... }:
      {
        virtualisation = {
          containers.enable = true;
          podman = {
            enable = true;
            autoPrune.enable = true;
            dockerCompat = true;
            # expose /var/run/docker.sock for tools that expect the docker
            # socket
            dockerSocket.enable = true;
            # required for podman-compose dns to work
            defaultNetwork.settings.dns_enabled = true;
          };
        };
        environment.systemPackages = [ pkgs.podman-compose ];

        # https://buildpacks.io/docs/for-app-developers/how-to/special-cases/build-on-podman/
        systemd.services.podman.serviceConfig = {
          # ExecStart in a list sets multiple lines
          # ExecStart=
          # ExecStart=/nix/store/...
          #
          # ^ is needed to override a service's execstart command cause
          # otherwise it complains about multiple conflicting values
          #
          # explainer on this syntax:
          # https://github.com/NixOS/nixpkgs/issues/63703#issuecomment-504836857
          ExecStart = [
            ""
            "${lib.getExe pkgs.podman} $LOGGING system service --time=1800"
          ];
        };
      };
    provides.to-users = {
      # if i care enough, limit this by username, otherwise it's available to
      # all users
      #
      # but it's only me so i don't know if i care enough
      user.extraGroups = [ "podman" ];
    };
  };
}
