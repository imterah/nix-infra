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
    ./programs/kitty.nix
    ./programs/starship.nix
  ];

  targets.genericLinux.enable = true;

  programs.git.extraConfig.gpg.program = "/usr/bin/qubes-gpg-client-wrapper";

  home.username = "user";
  home.homeDirectory = "/home/user";
}
