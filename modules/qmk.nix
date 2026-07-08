{
  ...
}:

{
  # TODO is this needed? only needed if want vue, which i don't?
  # qmk firmware setup?
  # or should this be a shell in my qmk fork?
  # will this need teensy loader as well?
  den.aspects.qmk = {
    nixos = {
      hardware.keyboard.qmk.enable = true;
    };
  };
}
