{
  ...
}:

{
  # https://wiki.nixos.org/wiki/Virt-manager
  den.aspects.libvirt = {
    nixos =
      { pkgs, ... }:
      {
        virtualisation.libvirtd.enable = true;
        programs.virt-manager.enable = true;
        environment.systemPackages = [ pkgs.dnsmasq ];
        networking.firewall.trustedInterfaces = [ "virbr0" ];
      };
    provides.to-users = {
      # if i care enough, limit this by username, otherwise it's available to
      # all users
      #
      # but it's only me so i don't know if i care enough
      user.extraGroups = [ "libvirtd" ];
    };
  };
}
