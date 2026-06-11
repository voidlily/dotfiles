{
  lib,
  ...
}:

{
  den.aspects.nvidia = {
    # https://github.com/NixOS/nixpkgs/pull/468569#issuecomment-3621904554
    # https://github.com/NixOS/nixpkgs/issues/525154
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ nvtopPackages.full ];

        # note on nvidia application profiles:
        # https://wiki.archlinux.org/title/NVIDIA#nvidia-application-profiles-rc.d
        # this profile is only needed for niche things like niri, kwin has it
        # built into the shipped driver configs now
      };
    homeManager =
      { config, ... }:
      {
        nixpkgs.config.nvidia.acceptLicense = true;
      };
  };
}
