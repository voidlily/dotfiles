{ den, ... }:

{
  den.aspects.games = {
    # TODO the rest of these i can do after os migration
    includes = with den.aspects; [
      archipelago
      # bizhawk
      bottles
      dolphin
      dusklight
      # ed
      # itgmania
      # minecraft
      n64
      # temp commented out, builds take too long
      playdate
      # retroarch
      ringracers
      # snek
      steam
      uzdoom
      vr
    ];
  };
}
