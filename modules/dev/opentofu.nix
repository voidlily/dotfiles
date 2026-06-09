{
  ...
}:

{
  den.aspects.opentofu = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          tenv
          terraform-docs
          terraform-ls
        ];
      };
  };
}
