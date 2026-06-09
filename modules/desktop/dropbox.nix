{
  den,
  ...
}:

{
  den.aspects.dropbox = {
    includes = [
      (den.batteries.unfree [
        "dropbox"
        # dropbox embeds a firefox for login?
        "firefox-bin"
        "firefox-bin-unwrapped"
      ])
    ];
    homeManager = {
      services.dropbox.enable = true;
    };
  };
}
