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
              content = {
                "/root" = {
                  mountpoint = "/";
                  # mountOptions = ["compress=zstd" "noatime"];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  # mountOptions = ["compress=zstd" "subvol=persist" "noatime"];
                  mountOptions = ["subvol=persist" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd" "subvol=home" "noatime"];
                };
                "/nix" = {
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
}
