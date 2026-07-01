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
        home.packages = with pkgs; [
          # emacs wants ispell for a spell checker
          ispell

          # formatters/linters/lsp wanted by `doom doctor`
          bash-language-server
          # cc
          clang-tools
          # clojure
          cljfmt
          # data
          libxml2
          # docker
          dockfmt
          # go
          gomodifytags
          gopls
          gore
          gotests
          # haskell
          # TODO move to dev/haskell.nix
          haskell-language-server
          haskellPackages.hoogle
          cabal-install
          # js
          typescript-language-server
          # python, everything else i do via direnv, venv, and ruff
          python3
          # shell
          shellcheck
          shfmt
          # web
          html-tidy
          stylelint
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
