{ ... }:
{
  den.aspects.printing = {
    nixos =
      { pkgs, ... }:
      {
        # https://wiki.nixos.org/wiki/Printing
        #
        # most of this config is for IPP evewywherre (which my printer is
        # slightly too old for)
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };

        services.ipp-usb.enable = true;

        services.printing = {
          enable = true;
          drivers = with pkgs; [
            cups-filters
            cups-browsed
            # TODO this should be on the system not in this file
            brlaser
          ];
        };

        # TODO this _definitely_ should be on a different aspect
        # maybe something for the brother printer itself?
        hardware.printers = {
          ensureDefaultPrinter = "Brother_HL-2270DW";
          ensurePrinters = [
            {
              deviceUri = "ipp://192.168.1.149:631/ipp";
              name = "Brother_HL-2270DW";
              # this model is slightly too old to support IPP everywhere, so we
              # install drivers above
              model = "drv:///brlaser.drv/br2270d.ppd";
            }
          ];
        };
      };

    provides.to-users =
      { ... }:
      {
        # if i care enough, limit this by username, otherwise it's available to
        # all users
        #
        # but it's only me so i don't know if i care enough
        user.extraGroups = [ "lpadmin" ];
      };
  };
}
