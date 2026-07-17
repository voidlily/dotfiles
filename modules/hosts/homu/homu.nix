{ den, lib, ... }:

{
  den.hosts.x86_64-linux.homu = {
    users.lily = { };
  };

  den.aspects.homu = {
    includes = [
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
      den.aspects.zsa
      den.aspects.scanners
    ];
    nixos = { pkgs, ... }: {
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
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # arm is needed to rekey for arm hosts such as darwin, can also come in handy for building for remote hosts if necessary
      boot.binfmt = {
        emulatedSystems = [ "aarch64-linux" ];
        preferStaticEmulators = true;
      };

      # facter auto-detected hardware things like microcode, bluetooth, etc
      hardware.facter.reportPath = ./facter.json;

      # https://wiki.nixos.org/wiki/NVIDIA
      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
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

}
