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
    ## Bootstrap
    ./stacks/core/traefik/docker-compose.nix
    ./stacks/core/caddy/docker-compose.nix
    ./stacks/core/tailscale/docker-compose.nix
    ## Internal
    ./stacks/private/portainer.hofers.cloud/docker-compose.nix
    ./stacks/private/passbolt.hofers.cloud/docker-compose.nix
    ./stacks/private/pterodactyl.hofers.cloud/docker-compose.nix
    ./stacks/private/immich.hofers.cloud/docker-compose.nix
    ## Public
    ./stacks/public/terah.dev/docker-compose.nix
    ./stacks/public/mcaptcha.terah.dev/docker-compose.nix
    ./stacks/public/git.terah.dev/docker-compose.nix
    ./stacks/public/matrix.terah.dev/docker-compose.nix
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

  # VPN setup
  networking.wireguard.interfaces = {
    # Reverse Proxy
    wg0 = {
      ips = [ "10.10.0.3/24" ];
      privateKeyFile = config.sops.secrets.reverse_proxy_client_privkey.path;
      table = "69";

      postSetup = "ip rule add from 10.10.0.2 table 69";
      preShutdown = "ip rule del from 10.10.0.2 table 69";

      peers = [{
        publicKey = "QXDlW73/+hKJu6CPiCmpSWOXqKvJPC+b7E7iuvRpL2A=";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "terah.dev:55107";
        persistentKeepalive = 25;
      }];
    };

    # ProtonVPN
    wg1 = {
      ips = [ "10.2.0.2/32" ];
      privateKeyFile = config.sops.secrets.protonvpn_privkey.path;
      table = "70";

      postSetup = "ip rule add from 10.2.0.2 table 70";
      preShutdown = "ip rule del from 10.2.0.2 table 70";

      peers = [{
        publicKey = "OuhID2usMSMoGAiLExUhH0lrOMJQ3v8xFWS+6G3JLRs=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "149.102.227.30:51820";
        persistentKeepalive = 25;
      }];
    };
  };

  # Tailscale fixer-uppers
  networking.nat = {
    enable = true;
    enableIPv6 = true;

    internalInterfaces = [ "enp6s18" ];
    externalInterface = "wg0";
  };

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
