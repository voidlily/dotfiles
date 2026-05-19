{ inputs, ... }:

{
  imports = [
    (inputs.import-tree [
      ../legacymodules
      ../users
      ../hosts/homu/_homeManager
      ../hosts/lilys-MacBook-Pro/_darwin
      ../hosts/Lily-Rappaport-TM1069/_darwin
    ])
  ];
}
