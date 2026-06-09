{
  ...
}:

{
  den.aspects.udisks2 = {
    nixos = {
      programs.gnome-disks.enable = true;
      services.udisks2.enable = true;
    };
  };
}
