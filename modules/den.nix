{
  inputs,
  den,
  lib,
  self,
  ...
}:
{
  # stateVersion determines defaults at time of initial creation
  # do not update without _very good reason_
  den.default.nixos.system.stateVersion = "23.11";
  den.default.homeManager.home.stateVersion = "23.11";
  # darwin-rebuild changelog
  den.default.darwin.system.stateVersion = 4;

  den.default.nixos.imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  den.default.darwin.imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  den.default.homeManager.imports = [ ];

  imports = [ inputs.den.flakeModule ];

  den.default.includes = [
    den.batteries.inputs'
    den.batteries.self'
  ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.schema.host.includes = [
    den.batteries.hostname
    den.batteries.host-aspects
  ];
  den.schema.user.includes = [
    den.batteries.mutual-provider
  ];

  # TODO extract each entry to hosts/hostname folders
  # TODO kernel parameters like nvidia related stuff?
  # TODO one more pass at things missed in systemd units. systemd user units, and /etc
  # den.hosts.x86_64-linux.homu.users.lily = { };
  den.hosts.x86_64-linux.homu2 = {
    users.lily = {
      aspect = den.aspects.lily.linux;
    };
  };
  # TODO move me
  den.aspects.desktop = {
    includes = with den.aspects; [
      _1password
      baobab
      calibre
      discord
      dropbox
      firefox
      fonts
      ghostty
      gimp
      # TODO pending install and secrets
      halloy
      input
      # jellyfin
      kde
      libreoffice
      mpv
      obs-studio
      obsidian
      pipewire
      # temp commented out, makes builds take too long
      # plover
      prusa-slicer
      signal
      slack
      # TODO pending install and secrets
      # streamlink
      syncthing
      udisks2
      # yubikey
      zoom
    ];
  };
  # TODO move me
  den.aspects.games = {
    # TODO the rest of these i can do after os migration
    includes = with den.aspects; [
      archipelago
      # bizhawk
      bottles
      dolphin
      dusklight
      # ed
      # itgmania
      # minecraft
      n64
      # temp commented out, builds take too long
      # playdate
      # retroarch
      ringracers
      # snek
      steam
      uzdoom
      vr
    ];
  };
  # TODO
  den.aspects.shell-full = {
    includes = with den.aspects; [
      minimal
      emacs
      # # TODO does not include nix, nh, etc?
      nix-dev
      git
      jj
      # # TODO is ruff, uv, etc part of python?
      # python
      # ruby
      linters
      # # TODO split up "devops" in homecommon by concern more - aws, gcp, etc
      # devops
      opentofu
      k8s
      # security
      # clojure
      # zellij
      # vim
      # atuin
      bat
      direnv
      comma
    ];
  };
  den.aspects.homu2 = {
    includes = [
      (den.batteries.vm-autologin "lily")
      den.aspects.minimal
      den.aspects.shell-full
      den.aspects.gpg
      den.aspects.nix
      den.aspects.desktop
      den.aspects.games
      den.aspects.printing
      den.aspects.tailscale

      den.aspects.containers
      den.aspects.libvirt
      den.aspects.networkmanager
      den.aspects.openssh
      den.aspects.ddns
    ];
   nixos =
      { config, ... }:
      {
        time.timeZone = "America/Los_Angeles";
        # home-manager.useGlobalPkgs = true;
        nixpkgs.config.nvidia.acceptLicense = true;
        nixpkgs.config.allowUnfree = true;
        home-manager.useUserPackages = true;
        # users.mutableUsers = false;
        # unneeded, on vm the uid for lily is 1000 and gid is 100 for "users"
        # users.users.lily.uid = 1000;

        fileSystems = {
          "/" = {
            # TODO this uuid might change if wiped
            # device = "/dev/disk/by-uuid/ccbffb51-47c5-47ea-adb4-03ee73dfff8b";
            label = "root";
            fsType = "ext4";
            options = [
              "defaults"
              # noatime makes trim better
              # https://wiki.nixos.org/wiki/Filesystems#SSD_TRIM_support
              "noatime"
            ];
          };
          "/home" = {
            # device = "/dev/disk/by-uuid/3e43185a-37af-4d24-8987-674260d80937";
            label = "home";
            fsType = "ext4";
            options = [
              "defaults"
              "noatime"
            ];
          };
          "/boot" = {
            # device = "/dev/disk/by-uuid/B0E1-6D16";
            label = "ESP";
            fsType = "vfat";
            options = [
              "defaults"
              "noatime"
            ];

          };
          "/mnt/vm" = {
            # device = "/dev/disk/by-uuid/8fd87e82-d580-4581-876c-394a538ae4b1";
            label = "vm";
            fsType = "ext4";
            options = [
              "defaults"
              "noatime"
            ];
          };

          # "/mnt/anime" = { };
          # "/mnt/downloads" = { };
          # "/mnt/movies" = { };
          # "/mnt/tv" = { };
          # "/mnt/video" = { };
          # "/mnt/music" = { };
          # "/mnt/emulation" = { };
        };
        boot.loader.systemd-boot.enable = true;
        boot.loader.systemd-boot.editor = false;

        # arm is needed to rekey for arm hosts such as darwin, can also come in handy for building for remote hosts if necessary
        boot.binfmt = {
          emulatedSystems = [ "aarch64-linux" ];
          preferStaticEmulators = true;
        };

        # facter auto-detected hardware things like microcode, bluetooth, etc
        hardware.facter.reportPath = ./hosts/homu/facter.json;

        # https://wiki.nixos.org/wiki/NVIDIA
        hardware.graphics.enable = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia.open = true;
        hardware.nvidia.branch = "latest";

        # all unfree firmware, including broadcom bluetooth among others
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/hardware/all-firmware.nix
        hardware.enableAllFirmware = true;

        # https://wiki.nixos.org/wiki/Fwupd
        services.fwupd.enable = true;

        services.thermald.enable = true;

        age.rekey = {
          # TODO rekey with actual host key after install
          hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        };
      };
    # TODO move me to somewhere else later
    homeManager =
      { pkgs, ... }:
      {
        services.gpg-agent.pinentry.package = lib.mkForce pkgs.pinentry-gnome3;
        targets.genericLinux.enable = lib.mkForce false;
        age.rekey = {
          # TODO rekey with actual host key after install
          hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        };
      };
  };

  den.hosts.x86_64-darwin.lilys-MacBook-Pro = {
    users.lily = {
      aspect = den.aspects.lily.darwin;
    };
  };

  den.aspects.lilys-MacBook-Pro = {
    includes = [
      den.batteries.hostname
      den.aspects.darwinCommon
      den.aspects.shell-full
      den.aspects.minimal
    ];
    darwin =
      { pkgs, ... }:
      {
        nix.settings.trusted-users = [
          "root"
          "lily"
        ];

        age.rekey = {
          # hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        };
      };
  };

  den.homes.x86_64-linux."lily@homu" = {
    aspect = den.aspects.lily.linux;
  };

  den.homes.x86_64-linux."lily@homu2" = { };

  den.aspects.lily = { };

  # TODO i don't like this, there has to be a way to do this with either
  # policies or something else?
  #
  # i think i need to aspectify this before i can policyfy this, the homeManager
  # and imports stuff is uh..... a workaround for non-denful modules? shrug
  den.aspects.lily.linux = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.homeCommon
      den.aspects.nvidia
      den.aspects.k8s

      den.aspects.gpg
      # homecommon
      # TODO this goes on the host eventually, not the user
      # it's only on the user at all for standalone home testing
      den.aspects.minimal
      den.aspects.shell-full
      den.aspects.fonts
      den.aspects.ghostty
      den.aspects.aws
      (den.batteries.unfree [ "nvidia-x11" ])
    ];
    # TODO make me a hashed password and secret
    nixos = {
      users.users.lily.password = "test";
      nixpkgs.config.nvidia.acceptLicense = true;
    };
    homeManager =
      { pkgs, ... }:
      {
        # TODO this is getting littered around *everywhere*, find where to actually put it once and for all
        nixpkgs.config.nvidia.acceptLicense = true;
        # TODO combine with above in host
        services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

        # TODO remove me
        targets.genericLinux = {
          # enable genericLinux things to better run on non-nixos
          enable = true;
          gpu.nvidia = {
            enable = true;
            # nvidia driver version must match host driver version
            version = "595.71.05";
            sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
          };
        };
        age.rekey = {
          # TODO rekey with actual host key after install
          hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        };
      };
  };

  # TODO needs to be tested on darwin
  den.aspects.lily.darwin = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.homeCommon
    ];
    homeManager =
      { config, pkgs, ... }:
      {
        # TODO move elsewhere
        programs.doom-emacs = {
          emacs = pkgs.nur.repos.natsukium.emacs-plus;
        };
        # TODO move elsewhere?
        services.gpg-agent.pinentry.package = null;
      };
  };

  flake.den = den;
  # https://den.denful.dev/explanation/diagrams/#quick-start
  # nix eval ".#diag" --raw | wl-copy
  # then paste it into https://mermaid.live or something
  flake.diag = den.lib.diag.toMermaid (
    den.lib.diag.hostContext { host = den.hosts.x86_64-linux.homu2; }
    # den.lib.diag.homeContext { home = den.homes.x86_64-linux."lily@homu"; }
  );
}
