{device ? throw "Set this to your disk device, e.g. /dev/disk/by-id/...", ...}: {
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            rootfs = {
              size = "100%";
              name = "NixOS";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  root = {
                    name = "root";
                    mountpoint = "/";
                  };
                  persist = {
                    name = "persist";
                    mountpoint = "/persist";
                    mountOptions = ["subvol=persist" "noatime"];
                  };
                  home = {
                    name = "home";
                    mountpoint = "/home";
                    mountOptions = ["subvol=home" "noatime"];
                  };
                  nix = {
                    name = "nix";
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "subvol=nix" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
