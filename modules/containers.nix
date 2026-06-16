{
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
