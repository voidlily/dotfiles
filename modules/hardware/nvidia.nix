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

        # note on nvidia modesetting: it's set to true by default since driver 535
        # https://wiki.nixos.org/wiki/NVIDIA

        # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
        # TODO this goes away with firefox 153 when we get vulkan video
        environment.variables.LIBVA_DRIVER_NAME = "nvidia";
        environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";
      };
    homeManager =
      { config, ... }:
      {
        nixpkgs.config.nvidia.acceptLicense = true;
        # TODO this goes away with firefox 153 when we get vulkan video
        programs.firefox.policies.Preferences =
          let
            ffVersion = config.programs.firefox.package.version;
          in
          {
            "media.ffmpeg.vaapi.enabled" = {
              Value = lib.versionOlder ffVersion "137.0.0";
              Status = "locked";
            };
            "media.hardware-video-decoding.force-enabled" = {
              Value = lib.versionAtLeast ffVersion "137.0.0";
              Status = "locked";
            };
            "media.rdd-ffmpeg.enabled" = {
              Value = lib.versionOlder ffVersion "97.0.0";
              Status = "locked";
            };

            "gfx.x11-egl.force-enabled" = {
              Value = true;
              status = "locked";
            };
            "widget.dmabuf.force-enabled" = {
              Value = true;
              Status = "locked";
            };

            # Set this to true if your GPU supports AV1.
            #
            # This can be determined by reading the output of the
            # `vainfo` command, after the driver is enabled with
            # the environment variable.
            "media.av1.enabled" = {
              # TODO there has to be a better way to set this
              Value = true;
              status = "locked";
            };
          };
      };
  };
}
