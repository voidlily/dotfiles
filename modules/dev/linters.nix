{
  ...
}:

{
  den.aspects.linters = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          markdownlint-cli2
          proselint
          prettier
          yamllint
        ];

        # TODO move python stuff
        programs.mypy.enable = true;

        programs.ruff = {
          enable = true;
          settings = { };
        };

        programs.uv.enable = true;

        programs.uv.settings = {
          keyring-provider = "subprocess";
        };
      };
  };
}
