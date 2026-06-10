{ den, ... }:

{
  den.hosts.x86_64-darwin.lilys-MacBook-Pro = {
    users.lily = { };
  };

  den.aspects.lilys-MacBook-Pro = {
    includes = [
      den.batteries.hostname
      den.aspects.darwinCommon
      den.aspects.shell-full
      den.aspects.minimal
    ];
    darwin = {
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
      { pkgs, ... }:
      {
        programs.doom-emacs = {
          emacs = pkgs.nur.repos.natsukium.emacs-plus;
        };
        services.gpg-agent.pinentry.package = null;
      };
  };

}
