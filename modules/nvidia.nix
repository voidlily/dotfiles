{
  config,
  lib,
  pkgs,
  ...
}:

{
  den.aspects.nvidia = {
    homeManager = {
      imports = [
        {
          nixpkgs.config.nvidia.acceptLicense = true;
        }
      ];
    };
  };
}
