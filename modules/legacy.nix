{ inputs, ... }:

{
  imports = [
    (inputs.import-tree [
      ../legacymodules
      ../packages
      ../users
      #../hosts/homu/_homeManager
      # (../homes + "/lily@homu" + /_homeManager)
      ../hosts/lilys-MacBook-Pro/_darwin
      ../hosts/Lily-Rappaport-TM1069/_darwin
    ])
  ];
}
