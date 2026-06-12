{
  inputs,
  ...
}:

{
  flake-file.inputs = {
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      # Optional, to download less. Neither the module nor the overlay uses this input.
      inputs.nixpkgs.follows = "";
    };
  };

  den.default.homeManager.imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  den.aspects.emacs = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          # emacs wants ispell for a spell checker
          pkgs.ispell
          # formatters wanted by `doom doctor`
          pkgs.shfmt
          pkgs.dockfmt
        ];
        home.sessionVariables = {
          # EDITOR = "emacs";
        };
        programs.doom-emacs = {
          enable = true;
          # TODO find a better way to reference root path of flake
          doomDir = ../doom.d;
          extraPackages = epkgs: [
            epkgs.treesit-grammars.with-all-grammars
          ];
        };
      };
  };
}
