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
      "audio"
      "docker"
      "input"
      "plugdev"
    ];

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../secrets/id_user.pub)
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "andromeda";
  networking.networkmanager.enable = true;
  boot.supportedFilesystems = [];

  # Services
  services.docker.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.unstable) htop btop micro nano;
  };

  system.stateVersion = "24.11";
}
