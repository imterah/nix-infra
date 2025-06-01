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
    ../../system/nh.nix

    ./caddy/docker-compose.nix
  ];

  users.mutableUsers = false;

  users.motd = ''
    Welcome to the Milky Way!
  '';

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

  security.sudo-rs.enable = true;

  networking.hostName = "milkyway";
  networking.networkmanager.enable = true;

  # btrfs swap configuration (snapshots need to be disabled so we have to do it this way apparently)
  # Not putting this in the persist/ directory is intentional. We want the file to regenerate on boot
  # so that if the swap file size changes, we can update it easily.
  #
  # We still check if the file exists though incase the service gets activated multiple times for some
  # dumb reason.
  systemd.services.swapinit = {
    enable = true;
    path = [ pkgs.btrfs-progs pkgs.util-linux ];
    serviceConfig = {
      ExecStart = "${pkgs.writeShellScriptBin "swapinit" ''
        if [ ! -f /swap ]; then
          btrfs filesystem mkswapfile --size 4g --uuid clear /swap
        fi

        swapon | grep "/swap file"
        SWAP_NOT_RUNNING=$?

        if [ "$SWAP_NOT_RUNNING" -eq 1 ]; then
          swapon /swap
        fi
      ''}/bin/swapinit";
    };
  };

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
      listenPort = 55107;
      ips = ["10.10.0.1/24"];
      privateKeyFile = config.sops.secrets.reverse_proxy_server_privkey.path;

      peers = [
        {
          publicKey = "X8dbqb9DUX8SxZCGI/QxtzOg1aVrO9X7B4RF5PSdWkM=";
          allowedIPs = ["10.10.0.3/32"];
        }
      ];
    };
  };

  # Tailscale fixer-uppers
  networking.nat = {
    enable = true;
    enableIPv6 = true;

    internalInterfaces = ["enp6s18"];
    externalInterface = "wg0";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) htop btop micro nano;
  };

  # The VPS host has its own firewall. Might as well make it their job.
  networking.firewall.enable = false;
  system.stateVersion = "25.05";
}
