{
  ...
}:

{
  # TODO implement if wanted (after os swap)
  # https://wiki.nixos.org/wiki/CCache
  # ^^ the sloppiness random_seed required config the wiki page mention might break reproducibility
  # but also seems to be required to actually get caching to worrk
  # need to more deeply consider the tradeoffs
  den.aspects.ccache = { };
}
