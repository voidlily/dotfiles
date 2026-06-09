{
  den,
  ...
}:

{
  # TODO split up
  # move vuescan stuff to scanners?
  den.aspects.localpackages = {
    includes = [
      (den.batteries.unfree [
        "vuescan"
      ])
    ];
    nixos =
      { self', ... }:
      {
        environment.systemPackages = [ self'.packages.vuescan ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          # TODO extract
          (pkgs.pack.overrideAttrs (
            final: prev: {
              version = "0.40.2";
              src = pkgs.fetchFromGitHub {
                owner = "buildpacks";
                repo = "pack";
                tag = "v${final.version}";
                hash = "sha256-fFNC0U9pxZ2iaYEf5FQcVQJF1B/2P9UxQdeNqt7r+UI=";
              };
              vendorHash = "sha256-Mawgo6ppIfifNh0xGHxN6jRq07PeghcDOhekexQFPas=";
            }
          ))
        ];
      };
  };
}
