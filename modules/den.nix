{
  inputs,
  den,
  lib,
  self,
  ...
}:
{
  # den.default.nixos.system.stateVersion = "23.11";
  # den.default.homeManager.system.stateVersion = "23.11";
  # den.default.darwin.system.stateVersion = 4;

  imports = [ inputs.den.flakeModule ];

  den.default.includes = [ den.batteries.self' ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.schema.host.includes = [
    (den.batteries.import-tree.host ../hosts)
  ];
  den.schema.home.includes = [
    (den.batteries.import-tree.home ../homes)
  ];
  den.schema.user.includes = [
    den.batteries.mutual-provider
    (den.batteries.import-tree.user ../users)
  ];

  # den.hosts.x86_64-linux.homu.users.lily = { };
  den.homes.x86_64-linux."lily@homu" = { };

  den.aspects.homu = {
    includes = [ den.batteries.hostname ];
  };

  den.aspects.lily = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      # TODO move this invocation closer to the aspect
      (den.batteries.unfree [
        "nvidia-x11"
        "shipwright"
        "2ship2harkinian"
        "starship-sf64"
        "spaghettikart"
        "1password-cli"
        "symbola"
      ])
      # TODO move this into playdatemirror aspect
      (den.batteries.insecure [ "libsoup-2.74.3" ])
    ];
    homeManager =
      { pkgs, self', ... }:
      {
        imports = [
          self.homeModules.homeCommon
          self.homeModules.homeLinux
          self.homeModules.homuPackages
          inputs.nix-index-database.homeModules.default
          inputs.direnv-instant.homeModules.direnv-instant
          inputs.nix-doom-emacs-unstraightened.homeModule
          {
            nixpkgs.config.nvidia.acceptLicense = true;
          }
          {
            home.packages = [
              # TODO extract
              self'.packages.stakk
              self'.packages.lns
              # TODO extract
              (pkgs.pack.overrideAttrs (
                final: prev: {
                  version = "0.40.2";
                  src = pkgs.fetchFromGitHub {
                    owner = "buildpacks";
                    repo = "pack";
                    tag = "v${final.version}";
                    hash = "sha256-fFNC0U9pxZ2iaYEf5FQcVQJF1B/2P9UxQdeNqt7r+UI=";
                  };
                  vendorHash = "sha256-Mawgo6ppIfifNh0xGHxN6jRq07PeghcDOhekexQFPas=";
                }
              ))
            ];
          }
        ];
      };
  };

  flake.den = den;
}
