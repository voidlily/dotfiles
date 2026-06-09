{
  inputs,
  den,
  lib,
  ...
}:
{
  # stateVersion determines defaults at time of initial creation
  # do not update without _very good reason_
  den.default.nixos.system.stateVersion = "23.11";
  den.default.homeManager.home.stateVersion = "23.11";
  # darwin-rebuild changelog
  den.default.darwin.system.stateVersion = 4;

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
  den.hosts.x86_64-linux.homu = {
    users.lily = { };
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
      streamlink
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
  den.aspects.homu = {
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
      den.aspects.nvidia

      den.aspects.containers
      den.aspects.libvirt
      den.aspects.networkmanager
      den.aspects.openssh
      den.aspects.ddns

      # don't love this here but it's okay for now
      den.aspects.aws
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

        i18n.defaultLocale = "en_US.UTF-8";

        fileSystems = {
          "/" = {
            # TODO this uuid might change if wiped
            device = "/dev/disk/by-uuid/e32f1197-5d61-4829-ba44-41628b49c57f";
            # label = "root";
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

        boot.loader.systemd-boot = {
          enable = true;
          editor = false;
          configurationLimit = 5;
        };
        boot.loader.efi.canTouchEfiVariables = true;
        boot.tmp.useTmpfs = true;

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
          hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHrlMsLhbl+TVkx22r9OkfZgJlMIbpIrBtGE/+gLS+T";
        };

        nix.settings.trusted-users = [
          "root"
          "lily"
        ];
      };
    # TODO move me to somewhere else later
    homeManager =
      { pkgs, ... }:
      {
        services.gpg-agent.pinentry.package = lib.mkForce pkgs.pinentry-qt;
        targets.genericLinux.enable = lib.mkForce false;
        age.rekey = {
          hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHrlMsLhbl+TVkx22r9OkfZgJlMIbpIrBtGE/+gLS+T";
        };
      };
  };

  den.hosts.x86_64-darwin.lilys-MacBook-Pro = {
    users.lily = {
      aspect = den.aspects.lily;
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
        # TODO make this less copypasted somehow?
        nix.settings.trusted-users = [
          "root"
          "lily"
        ];

        age.rekey = {
          # hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        };
      };

    # don't love this here it should be mac specific somehow
    # TODO darwin-common?
    homeManager =
      { config, pkgs, ... }:
      {
        programs.doom-emacs = {
          emacs = pkgs.nur.repos.natsukium.emacs-plus;
        };
        services.gpg-agent.pinentry.package = null;
      };
  };

  den.aspects.lily = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.homeCommon
    ];
    # TODO make me a hashed password and secret
    nixos = {
      users.users.lily.password = "test";
    };
  };

  flake.den = den;
  # https://den.denful.dev/explanation/diagrams/#quick-start
  # nix eval ".#diag" --raw | wl-copy
  # then paste it into https://mermaid.live or something
  flake.diag = den.lib.diag.toMermaid (
    den.lib.diag.hostContext { host = den.hosts.x86_64-linux.homu; }
  );
}
