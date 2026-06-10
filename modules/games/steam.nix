{ den, ... }:

{
  den.aspects.steam = {
    includes = [ (den.batteries.unfree [ "steam" ]) ];
    nixos =
      { pkgs, ... }:
      {
        # steam-run for non-nix binaries that expect FHS and aren't easily
        # patchable
        #
        # usage: `steam-run ./program`
        environment.systemPackages = [ pkgs.steam-run ];
        # if nix-ld is desired instead of prefixing commands with steam-run
        # https://wiki.nixos.org/wiki/FAQ#I've_downloaded_a_binary,_but_I_can't_run_it,_what_can_I_do?
        # programs.nix-ld = {
        #   enable = true;
        #   libraries = pkgs.steam-run.args.multiPkgs pkgs;
        # };

        programs.gamemode.enable = true;
        programs.steam = {
          enable = true;

          # https://wiki.vronlinux.org/docs/distros/nixos/#steam-games-and-openvr-apps
          package = pkgs.steam.override {
            extraProfile = ''
              # Allows Monado/WiVRn to be used
              export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
              # Fixes timezones on VRChat
              unset TZ
            '';
            # https://old.reddit.com/r/NixOS/comments/1htxgly/steam_not_using_cursor_theme/
            # https://github.com/keenanweaver/nix-config/blob/219164fb75e3c8a16bdc71884778caa38a9339f4/modules/apps/steam/default.nix#L72
            # add kde cursor to the FHS env
            extraPkgs = (pkgs: with pkgs; [ kdePackages.breeze ]);
          };

          extraCompatPackages = with pkgs; [
            proton-ge-bin
            dwproton-bin
          ];

          remotePlay.openFirewall = true;
        };
      };
  };
}
