{
  den,
  inputs,
  ...
}:
{
  # TODO this module needs the big split up
  # each group of packages in home.packages gets split into an aspect
  # each program.whatever gets split into an aspect
  den.aspects.homeCommon = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {

        programs.man.enable = true;
        home.packages = [

          pkgs.microplane

          # ruby
          (pkgs.ruby.withPackages (rpkgs: [ rpkgs.solargraph ]))

          # devops
          pkgs.glab
          # broken on darwin due to failing tests?
          # pkgs.open-policy-agent
          # pkgs.pack
          pkgs.postgresql
          pkgs.ssm-session-manager-plugin
          pkgs.velero

          # yubikey
          pkgs.yubikey-manager

          # security
          pkgs.cosign
          pkgs.grype
          pkgs.syft
        ];

        # Home Manager is pretty good at managing dotfiles. The primary way to manage
        # plain files is through 'home.file'.
        home.file = {
          # # Building this configuration will create a copy of 'dotfiles/screenrc' in
          # # the Nix store. Activating the configuration will then make '~/.screenrc' a
          # # symlink to the Nix store copy.
          # ".screenrc".source = dotfiles/screenrc;

          # # You can also set the file content immediately.
          # ".gradle/gradle.properties".text = ''
          #   org.gradle.console=verbose
          #   org.gradle.daemon.idletimeout=3600000
          # '';

          ".clojure".source = ../clojure;
          ".gemrc".source = ../gemrc;
          ".irbrc".source = ../irbrc;
          ".pryrc".source = ../pryrc;
        };
      };
  };
}
