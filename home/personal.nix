{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    ./core.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/gnome.nix
    ./programs/zellij.nix
    ./programs/starship.nix
    ./programs/alacritty.nix
  ];

  home.username = "tera";
  home.homeDirectory = "/home/tera";
}
