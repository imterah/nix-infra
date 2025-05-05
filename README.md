# Tera's NixOS Home Infrastructure

Work-in-progress NixOS Server Infrastructure based on [valerie's NixOS setup](https://git.dessa.dev/valnyx/nixos/src/branch/main).

## WARNING

This is a work-in-progress and currently DOES NOT WORK. Please check back later.

## Setup

### Bootstrapping a New Device

This guide assumes you have a somewhat sane sops setup.

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
7. Copy/clone the configuration over to the host to install.
8. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount -f "$PWD#hostname"` to prepare the disk, replacing `hostname` with the host you want to switch to (ex. `andromeda`).
