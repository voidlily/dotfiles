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

  flake.den = den;
  # https://den.denful.dev/explanation/diagrams/#quick-start
  # nix eval ".#diag" --raw | wl-copy
  # then paste it into https://mermaid.live or something
  flake.diag = den.lib.diag.toMermaid (
    den.lib.diag.hostContext { host = den.hosts.x86_64-linux.homu; }
  );
}
