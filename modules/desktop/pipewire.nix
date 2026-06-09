{
  ...
}:

{
  # xdg-desktop-portal-kde etc are provided by default by plasma6
  den.aspects.pipewire = {
    nixos = {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };
  };
}
