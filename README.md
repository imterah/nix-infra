# Tera's NixOS Home Infrastructure

Work-in-progress NixOS Server Infrastructure based on [valerie's NixOS setup](https://git.dessa.dev/valnyx/nixos/src/commit/fe5d9a5d2275157d3c8da527fe467e1587a86bfe).

## WIP

This is a work-in-progress and currently is not production ready. Please check back later.

### Checklist

  - [x] Get basic install working
  - [x] Configure reverse proxy
  - [x] Configure firewall
  - [x] Install Docker
  - [x] Configure NFS mount
  - [x] Configure Traefik & its dashboard
  - [x] Configure Caddy for internal service port forwarding (difficult!)
  - [ ] Install Portainer for other servers & basic admin tasks
  - [ ] Install Forgejo
  - [ ] Install Personal Website
  - [ ] Install Passbolt
  - [ ] Install Pterodactyl Panel
  - [ ] Install Immich
  - [ ] Restore Forgejo
  - [ ] Restore Passbolt
  - [ ] Restore Pterodactyl Panel
  - [ ] Restore Immich (difficult!)
  - [ ] Get myself a treat :3

## Manifesto

I want to have ultra reliable and secure infrastructure for my personal use. These goals are met using the following things:
  - Heavily documented and reproducible infrastructure
  - Ultra-reliability and higher security via impermanent infrastructure
  - Not using a system that is flawed from the start (my poor Kubernetes setup)

This server setup uses Docker, but not Docker Compose. Instead, we use NixOS built in OCI support, and `compose2nix` to help facilitate the setup of OCI containers.

I don't want obscure software patches (even if reliable!) needed for Nix. I want the official distributions, which is why I'm not using Nixpkgs (ie. `services.immich.enable = true;`).

## Setup

### Setting up Sops

TODO.

### Bootstrapping a New Device

1. First, boot the NixOS live environment (minimal ISO is recommended).
2. Then, get the harddrive ID using `lsblk` or `fdisk -l`:

   ```bash
   sudo fdisk -l
   ls -lah /dev/disk/by-id | grep -i <drive disk ID ie. sda>
   ```

   Example output:

   ```bash
   [nix-shell:~]$ sudo fdisk -l
   Disk /dev/loop0: 1.14 GiB, 1221455872 bytes, 2385656 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes


   Disk /dev/sda: 256 GiB, 274877906944 bytes, 536870912 sectors
   Disk model: QEMU HARDDISK
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes

   [nix-shell:~]$ ls -lah /dev/disk/by-id | grep -i sda
   lrwxrwxrwx 1 root root   9 May  5 13:20 scsi-0QEMU_QEMU_HARDDISK_drive-scsi0 -> ../../sda

   [nix-shell:~]$ # disk path: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0
   ```

3. Manually create a host configuration by modifying/duplicating `hosts/<target_host_to_base_off_of>` to `hosts/<new_host_name>`. Be sure to modify the hostname in `hosts/<new_host_name>/configuration.nix`.
4. Add the host to `flake.nix`.
5. Modify the disko configuration for our host to use the correct disk ID that we found earlier.
6. Make any other additional modifications if needed.

### Installing the Configuration

1. Copy/clone the configuration over to the host to install and `cd` into it.
2. Copy the sops key data to the host you are installing on (sops `key.txt` and `ssh_host_ed25519_key` to `/var/lib/sops-nix/`)
3. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount -f "$PWD#hostname"` to prepare the disk, replacing `hostname` with the host you want to install (ex. `andromeda`).
4. Before installing, prepare sops inside the mounted filesystem: `sudo mkdir -p /mnt/persist/var/lib/sops-nix/; sudo cp -r /var/lib/sops-nix/ /mnt/persist/var/lib/; sudo chmod -R 755 /mnt/persist/var/lib/sops-nix/`
5. Run `sudo nixos-install --flake "$PWD#hostname"` to install the OS, replacing `hostname` with the host you want to install (ex. `andromeda`).
6. Copy the current configuration into `/etc/nixos`: `sudo cp -r $PWD/. /mnt/persist/etc/nixos`
