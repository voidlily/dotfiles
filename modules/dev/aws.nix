{
  ...
}:

{
  den.aspects.aws = {
    homeManager =
      { pkgs, ... }:
      {
        programs.awscli.enable = true;
        home.packages = with pkgs; [ eks-node-viewer ];
      };
  };
}
