{
  home-manager,
  config,
  pkgs,
  lib,
  ...
}: {
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
    EDITOR = "${pkgs.zed-editor}/bin/zeditor -w";
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["floorp.desktop"];
    "x-scheme-handler/https" = ["floorp.desktop"];
    "text/html" = ["floorp.desktop"];
    "application/pdf" = ["floop.desktop"];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.package = pkgs.nix;

  home.stateVersion = "23.11";
}
