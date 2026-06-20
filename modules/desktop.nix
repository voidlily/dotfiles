{ den, ... }:

{
  den.aspects.desktop = {
    includes = with den.aspects; [
      _1password
      baobab
      calibre
      discord
      dropbox
      firefox
      fonts
      ghostty
      gimp
      halloy
      input
      # jellyfin
      kde
      libreoffice
      mpv
      obs-studio
      obsidian
      pipewire
      # temp commented out, makes builds take too long
      plover
      prusa-slicer
      signal
      slack
      streamlink
      syncthing
      udisks2
      yt-dlp
      zoom
    ];
  };
}
