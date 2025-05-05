{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../system/nix.nix
    ../../system/sops.nix
    ../../system/impermanence.nix
    ../../system/sshd.nix
    ../../system/avahifixes.nix
    ../../system/i18n.nix
  ];

  users.mutableUsers = false;

  users.users.tera = {
    uid = 1000;
    description = "Tera";
    home = "/home/tera";
    hashedPasswordFile = config.sops.secrets.tera_password.path;
    isNormalUser = true;
    createHome = true;
    shell = pkgs.bash;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../data/id_user.pub)
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "andromeda";
  networking.networkmanager.enable = true;
  boot.supportedFilesystems = [];

  # Services
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) htop btop micro nano;
  };

  system.stateVersion = "24.11";
}
