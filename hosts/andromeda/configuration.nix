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

    # Docker stacks
    ./andromeda/stacks/traefik/docker-compose.nix
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

    packages = with pkgs; [
      git
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
    autoPrune.enable = true;

    storageDriver = "btrfs";
  };

  virtualisation.oci-containers.backend = "docker";

  # Volumes
  fileSystems."/mnt/NASBox" = {
    device = "192.168.0.3:/mnt/Diskette/KubeData";
    fsType = "nfs";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) htop btop micro nano;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443 8000];
  };

  system.stateVersion = "24.11";
}
