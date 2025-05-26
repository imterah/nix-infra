{
  inputs,
  pkgs,
  lib,
  ...
}: let
  wallpaperspath = builtins.toString inputs.wallpapers;
in {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Zafiro-icons-Dark";
      package = pkgs.zafiro-icons;
    };

    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };

    cursorTheme = {
      name = "graphite-dark";
      package = pkgs.graphite-cursors;
    };
  };

  dconf = {
    enable = true;

    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;

        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "unite@hardpixel.eu"
        ];
      };

      "org/gnome/shell/extensions/user-theme" = {
        name = "Materia-dark";
      };

      "org/gnome/shell/extensions/unite" = {
        desktop-name-text = "Desktop";
        greyscale-tray-icons = true;
        hide-activities-button = "always";
        hide-window-titlebars = "always";
        show-window-buttons = "always";
        show-window-title = "tiled";
        window-buttons-placement = "first";
        window-buttons-theme = "arc";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "alacritty";
        name = "Open Terminal";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///${wallpaperspath}/IPJ02960.jpg";
        picture-uri-dark = "file:///${wallpaperspath}/IPJ02960.jpg";
      };
    };
  };

  home.packages = with pkgs; [
    # Gnome extensions
    gnomeExtensions.unite
    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-panel

    # Theme
    materia-theme
  ];
}
