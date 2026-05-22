{ lib, ... }:

{
  den.aspects.starship = {
    homeManager =
      { pkgs, ... }:
      {
        programs.starship = {
          enable = true;
          settings = {
            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$time"
              "$directory"
              # "$git_branch"
              # "$git_status"
              "\${custom.jj}"
              # "$c"
              # "$elixir"
              # "$elm"
              # "$golang"
              # "$gradle"
              # "$haskell"
              # "$java"
              # "$julia"
              # "$nodejs"
              # "$nim"
              # "$rust"
              # "$scala"
              # "$docker_context"
              "\${custom.spcr}"
              "$fill"
              "$cmd_duration"
              "$nix_shell"
              "$jobs"
              "$line_break"
              "$character"
            ];
            add_newline = true;
            palette = "solarized_dark";
            palettes.solarized_dark = {
              # ansi color order from old theme:
              # base02 red green yellow blue magenta cyan base2
              # base03 orange base01 base00 base0 violet base1 base3
              base03 = "#002b36";
              base02 = "#073642";
              base01 = "#586e75";
              base00 = "#657b83";
              base0 = "#839496";
              base1 = "#93a1a1";
              base2 = "#eee8d5";
              base3 = "#fdf6e3";
              yellow = "#b58900";
              orange = "#cb4b16";
              red = "#dc322f";
              magenta = "#d33682";
              violet = "#6c71c4";
              blue = "#268bd2";
              cyan = "#2aa198";
              green = "#859900";

              # remove these? were using for "character" but can just use the
              # solarized variants for consistency
              strong_green = "#5fd700";
              light_red = "#ff0000";
            };
            username = {
              show_always = true;
              style_user = "bg:base02 fg:base0";
              format = "[ $user@]($style)";
            };
            hostname = {
              ssh_only = false;
              ssh_symbol = "🌐";
              style = "bg:base02 fg:base0";
              format = "[$hostname$ssh_symbol ]($style)";
            };
            time = {
              disabled = false;
              style = "bg:green fg:base02";
              format = "[ ](fg:prev_bg bg:green)[$time ]($style)";
            };
            directory = {
              fish_style_pwd_dir_length = 2;
              style = "bg:blue fg:base02";
              format = "[ ](fg:prev_bg bg:blue)[$path ]($style)";
            };
            git_branch = {
              style = "bg:yellow fg:base02";
              format = "[ ](fg:prev_bg bg:yellow)[$branch ]($style)";
            };
            git_status = {
              conflicted = "=$count ";
              ahead = "⇡$count ";
              behind = "⇣$count ";
              diverged = "⇕$count ";
              untracked = "?$count ";
              stashed = "*$count ";
              modified = "!$count ";
              staged = "+$count ";
              renamed = "»$count ";
              deleted = "✘$count ";
              style = "bg:yellow fg:base02";
              format = "[$all_status$ahead_behind]($style)";
            };
            custom.spcr = {
              when = true;
              format = "[ ]($style)";
              style = "fg:prev_bg";
            };
            fill = {
              symbol = " ";
            };
            cmd_duration = {
              min_time = 3000;
              style = "bg:yellow fg:base02";
              format = "[ ](bg:prev_bg fg:yellow)[ $duration ]($style)";
            };
            jobs = {
              symbol = "";
              style = "bg:base02 fg:cyan";
              format = "[ ](bg:prev_bg fg:base02)[ $symbol $number ]($style)";
            };
            custom.jj = {
              format = "[ ](fg:prev_bg bg:yellow)[$output ]($style)";
              shell = [
                "${pkgs.jj-starship}/bin/jj-starship"
                "--no-color"
              ];
              style = "bg:yellow fg:base02";
              when = "${pkgs.jj-starship}/bin/jj-starship detect";
            };
            nix_shell = {
              style = "bg:base02 fg:cyan";
              format = "[ ](bg:prev_bg fg:base02)[ $symbol $state $name ]($style)";
            };
          };
        };
      };
  };
}
