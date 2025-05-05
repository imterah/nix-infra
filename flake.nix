{
  description = "Tera's Server Setup: 'When my data's tracking me, when my phone is spying, if not now, then when?'";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      overlays = import ./overlays.nix {inherit inputs;};

      sharedOverlays = [
        self.overlays.additions
        self.overlays.modifications
        self.overlays.unstable-packages
      ];

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
          (import ./hosts/andromeda/disko.nix {device = "/dev/disk/by-id/nvme-Samsung_SSD_979_PRO_with_Heatsink_1TB_S6WSNJ0T900943T";})
          inputs.impermanence.nixosModules.impermanence
          ./hosts/andromeda/configuration.nix
        ];
      };
  };
}
