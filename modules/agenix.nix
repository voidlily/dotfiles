{
  inputs,
  ...
}:
# TODO what to do with agenix
# https://github.com/oddlama/agenix-rekey
# https://github.com/str4d/age-plugin-yubikey
# https://fzakaria.com/2024/07/12/nix-secrets-for-dummies
# TODO smuggle the hostkey off homu before wiping and reinstalling?
{
  flake-file.inputs = {
    agenix.url = "github:ryantm/agenix";
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.agenix-rekey.flakeModule ];

  den.default.nixos.imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  den.default.darwin.imports = [
    inputs.agenix.darwinModules.default
    inputs.agenix-rekey.darwinModules.default
  ];

  den.default.homeManager.imports = [
    inputs.agenix.homeManagerModules.default
    inputs.agenix-rekey.homeManagerModules.default
  ];

  den.aspects.agenix =
    let
      age.rekey = {
        # TODO set me per host, maybe on a host attr? or just set age.rekey on the host and not put in that abstraction
        # hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZNpVXEe/N0tR33dlWfaPdLl6eDX9BG3dRhGXc2lZWZ";
        # if i add more yubikey identities, add them to this list
        # agenix-rekey by default picks the first identity
        #
        # when using rage, it errors out if the first identity yubikey isn't present, but age will prompt you to skip
        # consider switching agenix-rekey to use age instead of rage
        #
        # can also use AGENIX_REKEY_PRIMARY_IDENTITY when in doubt or using a different yubikey to rekey
        # https://github.com/oddlama/agenix-rekey#agenix_rekey_primary_identity
        masterIdentities = [
          ../age-yubikey-identity-bc4834fc.pub
          ../age-yubikey-identity-ee867b18.pub
          ../age-yubikey-identity-a36d98f5.pub
        ];
        # TODO change this to local mode, when i fully understand the tradeoffs, and then set the local storage folder either here or on the host in age.rekey
        storageMode = "local";
      };
    in
    {
      os =
        { config, ... }:
        {
          age.rekey = {
            inherit (age.rekey) masterIdentities storageMode;
            localStorageDir = ../. + "/secrets/rekeyed/${config.networking.hostName}";
          };
        };
      homeManager =
        { config, osConfig, ... }:
        {
          age.rekey = {
            inherit (age.rekey) masterIdentities storageMode;
            localStorageDir =
              ../.
              + "/secrets/rekeyed/${config.home.username}-${
                if (isNull osConfig) then "unknown" else osConfig.networking.hostName
              }";
          };
        };
    };
}
