{
  den,
  inputs,
  lib,
  ...
}:

{
  flake-file.inputs.steam-config-nix = {
    url = "github:different-name/steam-config-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default.nixos.imports = [
    inputs.steam-config-nix.nixosModules.default
  ];

  den.aspects.steam = {
    includes = [ (den.batteries.unfree [ "steam" ]) ];
    nixos =
      { pkgs, ... }:
      {
        # steam-run for non-nix binaries that expect FHS and aren't easily
        # patchable
        #
        # usage: `steam-run ./program`
        environment.systemPackages = [
          pkgs.steam-run
          pkgs.appimage-run
        ];
        # if nix-ld is desired instead of prefixing commands with steam-run
        # https://wiki.nixos.org/wiki/FAQ#I've_downloaded_a_binary,_but_I_can't_run_it,_what_can_I_do?
        # programs.nix-ld = {
        #   enable = true;
        #   libraries = pkgs.steam-run.args.multiPkgs pkgs;
        # };

        programs.gamemode.enable = true;
        programs.gamescope = {
          enable = true;
        };
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
          };

          extraPackages = with pkgs; [
            # https://old.reddit.com/r/NixOS/comments/1htxgly/steam_not_using_cursor_theme/
            # https://github.com/keenanweaver/nix-config/blob/219164fb75e3c8a16bdc71884778caa38a9339f4/modules/apps/steam/default.nix#L72
            # add kde cursor to the FHS env
            kdePackages.breeze
            gamescope
          ];

          extraCompatPackages = with pkgs; [
            proton-ge-bin
            dwproton-bin
          ];

          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };

        # this slightly weird repetition is done so nix doesn't parse an
        # attribute named "config" and think this module is defining config
        # attributes
        programs.steam.config.enable = true;
        programs.steam.config.apps =
          let
            gamescope-wrapper = [
              (lib.getExe pkgs.gamescope)
              "-W"
              "2560"
              "-H"
              "1440"
              "-w"
              "2560"
              "-h"
              "1440"
              "-b"
              "--"
            ];
          in
          {
            # TODO feeling cheeky? split up gamescope and mods into separate
            # aspects
            #
            # what this would do for me is nixos on the steam deck and auto
            # install my mods
            #
            # but steam deck doesn't necessarily need the gamescope portion

            # games that just need gamescope added to them
            "1910680" = {
              name = "Orb of Creation";
              compatTool = "proton_9";
            };
            "3224770" = {
              name = "Umamusume";
              compatTool = pkgs.proton-ge-bin;
            };
            "367520" = {
              name = "Hollow Knight";
              wrappers = gamescope-wrapper;
            };
            "1888160" = {
              name = "Armored Core 6";
              wrappers = gamescope-wrapper;
            };
            "502500" = {
              name = "Ace Combat 7";
              wrappers = gamescope-wrapper;
            };
            "881020" = {
              name = "Relink";
              wrappers = gamescope-wrapper;
            };
            "601150" = {
              name = "Devil May Cry 5";
              wrappers = gamescope-wrapper;
            };
            "898750" = {
              name = "Super Robot Wars 30";
              wrappers = gamescope-wrapper;
            };
            "1909950" = {
              name = "Super Robot Wars Y";
              wrappers = gamescope-wrapper;
            };
            "2008980" = {
              name = "Xenotilt";
              wrappers = gamescope-wrapper;
            };
            "1030300" = {
              name = "Silksong";
              wrappers = gamescope-wrapper;
            };
            "2393920" = {
              name = "Angeline Era";
              wrappers = gamescope-wrapper;
            };
            "3375780" = {
              name = "Trails 1st";
              wrappers = gamescope-wrapper;
            };
            "2864880" = {
              name = "Dungeon Gals";
              wrappers = gamescope-wrapper;
            };
            # setup notes:
            # https://codeberg.org/KHOmega/KH-Mods-Setup/src/branch/main/GoA-Randomizer-linux-setup.md
            # https://codeberg.org/KHOmega/KH-Mods-Setup/src/branch/main/refined-steam-linux-setup.md
            # https://github.com/iwuzhere9/KH2-Rando-Tracker-Linux-Guide
            # ^ tracker seems to not work, issues with autotracking and can't find kh2
            # nixos specific?
            #
            # other notes:
            # openkh is a non steam app and runs through there - requires proton experimental
            # kh2 rando is an appimage - doesn't like being a derivation
            #
            #
            # $HOME/openkh/settings.lua - the "set inverted camera" lua script
            # it's also set up as the "settings" mod
            # check if it still works on current version and/or with refined
            #
            # https://different-name.github.io/steam-config-nix/non-steam-apps.html - notes on non-steam apps
            #
            # top to bottom:
            # randoseed, settings, refined, goa rando
            #
            # archipelago:
            # apseed, settings, bear skip, ap QOL, apcompanion, apenablers (lite), refined, goa rando
            #
            # TODO pull this all out into its own module?
            # plop appimage in via home.files maybe? or does the autoupdate mess with that?
            "2252430" = {
              name = "Kingdom Hearts 2";
              compatTool = "proton_experimental";
              dllOverrides = {
                version = "n,b";
                LuaBackend = "n,b";
                dinput8 = "n,b";
              };
              wrappers = gamescope-wrapper;
            };
            "2523310" = {
              name = "Lingo 2";
              files.prefix.place = {
                "drive_c/users/steamuser/AppData/Roaming/Godot/app_userdata/Lingo 2/maps/archipelago.tscn".source =
                  pkgs.fetchurl
                    {
                      # specific commit rather than a floating one that could
                      # result in hash invalidation out from under us
                      url = "https://code.fourisland.com/lingo2-archipelago/plain/client/archipelago.tscn?h=dc00f07aa1dfd8b2170f83844c7cebf8ca7a113d";
                      hash = "sha256-+oZ7y+nvWd0LXoyeyB9qBW9sck7CS/YZQa/15DMi4hM=";
                    };
              };
            };
            "1173810" = {
              name = "ff5 pixel remaster";
              dllOverrides = {
                winhttp = "n,b";
              };
              wrappers = gamescope-wrapper;
              # TODO add cutscene skip mod too
              # also do i even want the mods?
              # https://github.com/NixOS/nixpkgs/pull/555543
              # files.game.place = {
              #   ".".source = pkgs.fetchzip {
              #     url = "https://github.com/BepInEx/BepInEx/releases/download/v6.0.0-pre.2/BepInEx-Unity.IL2CPP-win-x64-6.0.0-pre.2.zip";
              #     hash = "sha256-Yk4af4YJL4cg+RAw/+l0im5OLnU4ujWor6tRxGyGDMw=";
              #     stripRoot = false;
              #   };
              #   "BepInEx/plugins/".source = pkgs.fetchzip {
              #     url = "https://github.com/Silvris/Magicite/releases/download/v2.2.0/Magicite-2-2-0.zip";
              #     hash = "sha256-Yz/1K4ZkWEJ5O/F9kaVPzMhyOBvhi/tyb6IadqdiWzI=";
              #     stripRoot = false;
              #     postFetch = ''
              #       mv "$out/BepInEx/plugins/Magicite.bundle" "$out"
              #       mv "$out/BepInEx/plugins/Magicite.dll" "$out"
              #       mv "$out/BepInEx/plugins/Syldra.dll" "$out"
              #       rmdir "$out/BepInEx/plugins"
              #       rmdir "$out/BepInEx"
              #     '';
              #   };
              # };
            };
            "553420" = {
              name = "Tunic";
              dllOverrides = {
                winhttp = "n,b";
              };
              wrappers = gamescope-wrapper;
              files.game.place = {
                ".".source = pkgs.fetchzip {
                  url = "https://github.com/BepInEx/BepInEx/releases/download/v6.0.0-pre.1/BepInEx_UnityIL2CPP_x64_6.0.0-pre.1.zip";
                  hash = "sha256-Og3duLBwYJ2ae6vf2bm12KNyTOaO7gLzJ9huZPNXOTs=";
                  stripRoot = false;
                };
                "BepInEx/plugins/Tunic Randomizer".source = pkgs.fetchzip {
                  url = "https://github.com/silent-destroyer/tunic-randomizer/releases/download/5.0.1/TunicRandomizer.zip";
                  hash = "sha256-//ImaL9YPZFuKkvbMW1ai2L2FoZOvlA7h8nG+kfBDHM=";
                };
              };
            };
          };
      };
  };
}
