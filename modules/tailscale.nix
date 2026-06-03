{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.tailscale = {
    nixos = {
      # TODO if i need an authKeyFile it goes on the host aspect
      # can just interactively tailscale up on desktop for the time being
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "both";
      };
    };
  };
}
