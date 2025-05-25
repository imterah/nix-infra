{
  pkgs,
  lib,
  ...
}: {
  programs.alacritty = {
    enable = true;

    settings = {
      # Shell configuration
      terminal.shell.program = "${pkgs.zellij}/bin/zellij";
      env.EDITOR = "${pkgs.micro}/bin/micro";
      env.TERM = "xterm-256color";

      # Environment
      font.size = 12;
      font.normal.family = "Fixedsys Excelsior 3.01";
      font.bold.family = "Fixedsys Excelsior 3.01";
      font.italic.family = "Fixedsys Excelsior 3.01";
      font.bold_italic.family = "Fixedsys Excelsior 3.01";

      # Sizing
      window.padding.x = 4;
      window.padding.y = 4;
      window.startup_mode = "Maximized";

      # Catppuccin Mocha
      # https://github.com/catppuccin/alacritty/blob/main/catppuccin-mocha.toml
      colors.primary.background = "#1e1e2e";
      colors.primary.foreground = "#cdd6f4";
      colors.primary.dim_foreground = "#7f849c";
      colors.primary.bright_foreground = "#cdd6f4";

      colors.cursor.text = "#1e1e2e";
      colors.cursor.cursor = "#f5e0dc";

      colors.vi_mode_cursor.text = "#1e1e2e";
      colors.vi_mode_cursor.cursor = "#b4befe";

      colors.search.matches.foreground = "#1e1e2e";
      colors.search.matches.background = "#a6adc8";

      colors.search.focused_match.foreground = "#1e1e2e";
      colors.search.focused_match.background = "#a6e3a1";

      colors.footer_bar.foreground = "#1e1e2e";
      colors.footer_bar.background = "#a6adc8";

      colors.hints.start.foreground = "#1e1e2e";
      colors.hints.start.background = "#f9e2af";

      colors.hints.end.foreground = "#1e1e2e";
      colors.hints.end.background = "#a6adc8";

      colors.selection.text = "#1e1e2e";
      colors.selection.background = "#f5e0dc";

      colors.normal.black = "#45475a";
      colors.normal.red = "#f38ba8";
      colors.normal.green = "#a6e3a1";
      colors.normal.yellow = "#f9e2af";
      colors.normal.blue = "#89b4fa";
      colors.normal.magenta = "#f5c2e7";
      colors.normal.cyan = "#94e2d5";
      colors.normal.white = "#bac2de";

      colors.bright.black = "#585b70";
      colors.bright.red = "#f38ba8";
      colors.bright.green = "#a6e3a1";
      colors.bright.yellow = "#f9e2af";
      colors.bright.blue = "#89b4fa";
      colors.bright.magenta = "#f5c2e7";
      colors.bright.cyan = "#94e2d5";
      colors.bright.white = "#a6adc8";

      colors.indexed_colors = [
        {
          index = 16;
          color = "#fab387";
        }
        {
          index = 17;
          color = "#f5e0dc";
        }
      ];
    };
  };
}
