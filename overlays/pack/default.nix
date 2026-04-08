{
  ...
}:

final: prev: {
  pack = prev.pack.overrideAttrs (old: rec {
    version = "0.40.2";
    src = prev.fetchFromGitHub {
      owner = "buildpacks";
      repo = "pack";
      tag = "v${version}";
      hash = "sha256-fFNC0U9pxZ2iaYEf5FQcVQJF1B/2P9UxQdeNqt7r+UI=";
    };
    vendorHash = "sha256-Mawgo6ppIfifNh0xGHxN6jRq07PeghcDOhekexQFPas=";
  });
}
