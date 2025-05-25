{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["vhci_hcd" "usbip_core" "usbip_host" "evdi"];
  boot.kernelModules = ["kvm_intel"];
  boot.extraModulePackages = [pkgs.linuxPackages.evdi];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cbc3f550-4b9e-4ab1-95a2-166ee3a97a14";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/9d7ba577-a642-491f-9876-f39aa98d685d";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5420-E220";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
