{ den, ... }:

{
  den.aspects.lily = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
      den.aspects.homeCommon
    ];
    # TODO make me a hashed password and secret
    nixos = {
      users.users.lily = {
        password = "test";
        # the docs *say* each file should contain exactly one key, but nothing
        # stopping it from being "one or more"
        openssh.authorizedKeys.keyFiles = [ ../../yubikey-ssh.pub ];
      };
    };
  };
}
