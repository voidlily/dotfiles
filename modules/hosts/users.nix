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
      users.users.lily.password = "test";
    };
  };
}
