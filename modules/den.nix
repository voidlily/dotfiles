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

  # TODO don't love this, put it in an aspect later on
  den.default.nixos.imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.default
  ];

  den.default.darwin.imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-index-database.darwinModules.default
  ];

  den.default.homeManager.imports = [
    inputs.nix-index-database.homeModules.default
    inputs.direnv-instant.homeModules.direnv-instant
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  imports = [ inputs.den.flakeModule ];

  den.default.includes = [ den.batteries.self' ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.schema.host.includes = [ ];
  den.schema.user.includes = [
    den.batteries.mutual-provider
  ];

  # TODO extract each entry to hosts/hostname folders
  # den.hosts.x86_64-linux.homu.users.lily = { };
  den.hosts.aarch64-darwin.Lily-Rappaport-TM1069 = {
    users.lilyrappaport = {
      # TODO will this work with username?
      aspect = den.aspects.lily.darwin;
    };
  };

  den.aspects.Lily-Rappaport-TM-1069 = {
    includes = [
      den.batteries.hostname
      den.aspects.darwinCommon
    ];
    darwin =
      { pkgs, ... }:
      {
        nix.settings.trusted-users = [
          "root"
          "lilyrappaport"
        ];
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
    ];
    darwin =
      { pkgs, ... }:
      {
        nix.settings.trusted-users = [
          "root"
          "lily"
        ];
      };
  };

  den.homes.x86_64-linux."lily@homu" = {
    aspect = den.aspects.lily.linux;
  };

  den.aspects.homu = {
    includes = [ den.batteries.hostname ];
  };

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
      den.aspects.localpackages
      den.aspects.homeLinux
      den.aspects.homuPackages
      den.aspects.homeCommon
      den.aspects.nvidia
    ];
  };

  # TODO needs to be tested on darwin
  den.aspects.lily.darwin = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.localpackages
      den.aspects.homeDarwin
      den.aspects.homuPackages
      den.aspects.homeCommon
      den.aspects.nvidia
    ];
  };

  flake.den = den;
}
