{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,

  # All other arguments come from the module system.
  config,
  ...
}:
{
  options.dotfiles = lib.mkOption {
    type = lib.types.path;
    apply = toString;
    default = "${config.home.homeDirectory}/dotfiles";
    example = "${config.home.homeDirectory}/dotfiles";
    description = "Location of the dotfiles repo clone";
  };
}
