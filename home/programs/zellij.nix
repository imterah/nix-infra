{
  pkgs,
  lib,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

  # I give up.
  xdg.configFile."zellij/config.kdl" = {
    text = ''
      default_shell "${pkgs.zsh}/bin/zsh"
      show_startup_tips false
      theme "catppuccin-frappe"

      keybinds clear-defaults=true {
        normal {
          bind "Ctrl 1" { CloseTab; }
          bind "Ctrl 2" { NewTab; }
          bind "Ctrl 3" { GoToPreviousTab; }
          bind "Ctrl 4" { GoToNextTab; }
        }
      }

      ui {
        pane_frames {
          hide_session_name true
        }
      }
    '';
  };

  xdg.configFile."zellij/layouts/default.kdl" = {
    text = ''
      layout {
          pane borderless=false
          pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
          }
      }
      pane_frames false
    '';
  };
}
