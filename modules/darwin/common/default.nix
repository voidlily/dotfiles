{
  pkgs,
  ...
}:
{
  # Your configuration.
  environment.systemPackages = [
    pkgs.nur.repos.natsukium.emacs-plus
    pkgs.docker-credential-helpers
    pkgs.vim
  ];

  # Auto upgrade nix package and the daemon service.
  # disable, because nix is managed by determinate now
  nix.enable = false;
  # services.nix-daemon.enable = true;
  # TODO use the determinate flake for this?
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # enable touch id for sudo
  # TODO make this a config param and its own module
  # security.pam.enableSudoTouchIdAuth = true;

  # disable natural scrolling
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  # right click corner
  system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
  system.defaults.NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
}
