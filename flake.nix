{
  description = "Tera's Server Setup: 'When my data's tracking me, when my phone is spying, if not now, then when?'";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    disko = {
      url = "github:nix-community/disko";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    nh = {
      url = "github:viperML/nh";
    };
    nix-secrets = {
      url = "git+https://git.terah.dev/imterah/sops?shallow=1&ref=main";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    mkApp = flake-utils.lib.mkApp;
    mkFlake = flake-utils.lib.mkFlake;
  in mkFlake {
    inherit self inputs nixpkgs;

    hostDefaults.extraArgs = {inherit flake-utils;};
    hostDefaults.specialArgs = {
      inherit inputs;
      inherit (self) outputs;
    };

    # Main Docker-based host
    hosts.andromeda = {
      system = "x86_64-linux";
      modules = [
        inputs.disko.nixosModules.default
        (import ./hosts/andromeda/disko.nix {device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";})
        inputs.impermanence.nixosModules.impermanence
        ./hosts/andromeda/configuration.nix
      ];
    };
  };
}
