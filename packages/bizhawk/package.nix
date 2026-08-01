{
  callPackage,
  fetchFromGitHub,
  lua54Packages,
}:

# IFD shenanigans because they don't provide a flake yet
let
  package =
    callPackage
      (fetchFromGitHub {
        owner = "tasemulators";
        repo = "bizhawk";
        rev = "924ecce43423ffc4129ceb3178e4d2f2599d2027";
        hash = "sha256-60QSQEVasha/n4z5U9vMBvsrtSXhEFGNsP+bbffb4hI=";
      })
      {
        lua = lua54Packages.lua;
      };
in
package.emuhawk-latest-bin
